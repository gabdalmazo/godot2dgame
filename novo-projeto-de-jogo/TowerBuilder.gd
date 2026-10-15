class_name TowerBuilder
extends Node2D

## Gerenciador responsável por construir torres na grade (Grid) do TileMap.
## Converte o clique do mouse para coordenadas de mapa, valida espaço e economia,
## e alinha a torre perfeitamente no centro da célula usando map_to_local().
## Bloqueia automaticamente as células do caminho dos inimigos (Path2D).

@export var tilemap: Node2D
@export var tower_scene: PackedScene
@export var tower_cost: int = 50
@export var upgrade_cost: int = 100
@export var buildable_layer: int = 0
@export var require_tile: bool = false

const SFX_TOWER_PLACED = preload("res://assets/audio/sfx/tower_placed.ogg")

## Dicionário que armazena as coordenadas de grade (Vector2i) ocupadas por torres
var occupied_cells: Dictionary = {}

## Dicionário que armazena as coordenadas de grade (Vector2i) bloqueadas pelo caminho
var path_cells: Dictionary = {}

func _ready() -> void:
	# Fallback defensivo: se não foi atribuído no Inspector, busca nós de mapa na cena
	if tilemap == null:
		tilemap = get_parent().find_child("TileMap*", true, false) as Node2D
		if tilemap == null:
			tilemap = get_parent().find_child("*TileMapLayer*", true, false) as Node2D
	
	# Registra as células do caminho dos inimigos como bloqueadas
	_register_path_cells()
	
	# Registra torres pré-existentes na cena para que suas células já fiquem ocupadas
	if tilemap != null:
		for child in get_parent().get_children():
			if child is Tower:
				var existing_cell: Vector2i = tilemap.local_to_map(tilemap.to_local(child.global_position))
				occupied_cells[existing_cell] = child
				child.tree_exited.connect(func(): occupied_cells.erase(existing_cell))

func _register_path_cells() -> void:
	## Percorre todos os Path2D na cena e bloqueia as células ao longo do caminho.
	## Isso garante que torres NÃO possam ser construídas sobre o trajeto dos inimigos.
	if tilemap == null:
		return
	
	for child in get_parent().get_children():
		if child is Path2D and child.curve != null:
			var curve: Curve2D = child.curve
			var total_length: float = curve.get_baked_length()
			var step: float = 8.0  # Amostragem a cada 8 pixels para alta precisão
			var distance: float = 0.0
			
			while distance <= total_length:
				var point: Vector2 = curve.sample_baked(distance)
				var global_point: Vector2 = child.to_global(point)
				var cell: Vector2i = tilemap.local_to_map(tilemap.to_local(global_point))
				
				if not path_cells.has(cell):
					path_cells[cell] = true
				
				distance += step
			
			# Garante que o último ponto também seja registrado
			var last_point: Vector2 = curve.sample_baked(total_length)
			var last_global: Vector2 = child.to_global(last_point)
			var last_cell: Vector2i = tilemap.local_to_map(tilemap.to_local(last_global))
			path_cells[last_cell] = true
	
	print("[TowerBuilder] Células do caminho bloqueadas: ", path_cells.size())

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_try_build_tower()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			_try_sell_tower()

## Vende a torre presente na célula clicada com o botão direito, reembolsando metade do custo
func _try_sell_tower() -> void:
	if tilemap == null:
		return
		
	var mouse_pos: Vector2 = get_global_mouse_position()
	var local_mouse: Vector2 = tilemap.to_local(mouse_pos)
	var cell: Vector2i = tilemap.local_to_map(local_mouse)
	
	# Verifica se a coordenada clicada possui uma torre registrada
	if occupied_cells.has(cell):
		var tower: Node = occupied_cells[cell]
		var total_cost: int = tower_cost + (upgrade_cost if ("is_upgraded" in tower and tower.is_upgraded) else 0)
		var refund_value: int = total_cost / 2
		
		# 1. Devolve metade do valor ao jogador
		GameManager.adicionar_recursos(refund_value)
		
		# 2. Destrói a instância da torre
		if is_instance_valid(tower):
			tower.queue_free()
			
		# 3. Libera a célula do mapa para novas construções
		occupied_cells.erase(cell)
		
		NotificationManager.enviar_mensagem("Torre vendida! (+%d créditos)" % refund_value, Color(1.0, 0.85, 0.3))
		print("[TowerBuilder] Torre vendida na célula ", cell, " por ", refund_value, " créditos. Saldo: ", GameManager.recursos_globais)

## Aprimora a torre existente na célula clicada
func _try_upgrade_tower(cell: Vector2i) -> void:
	var tower: Node = occupied_cells.get(cell)
	if not is_instance_valid(tower):
		occupied_cells.erase(cell)
		return
		
	# 1. Limite de 1 nível de upgrade: impede aprimoramento infinito
	if "is_upgraded" in tower and tower.is_upgraded:
		AudioManager.tocar_erro()
		NotificationManager.enviar_mensagem("Esta torre já está no nível máximo!", Color(1.0, 0.7, 0.2))
		print("[TowerBuilder] Torre na célula ", cell, " já está no nível máximo.")
		return
		
	# 2. Verifica se o jogador possui recursos para o aprimoramento
	if not GameManager.possui_recursos(upgrade_cost):
		AudioManager.tocar_erro()
		NotificationManager.enviar_mensagem("Recursos insuficientes para upgrade! (Custo: %d)" % upgrade_cost, Color(1.0, 0.4, 0.4))
		print("[TowerBuilder] Recursos insuficientes para upgrade: ", upgrade_cost, " | Disponível: ", GameManager.recursos_globais)
		return
		
	# 3. Deduz o valor e aplica a melhoria diretamente na torre
	if GameManager.gastar_recursos(upgrade_cost):
		if tower.has_method("aplicar_upgrade"):
			tower.aplicar_upgrade()
		AudioManager.tocar_sfx(SFX_TOWER_PLACED)
		NotificationManager.enviar_mensagem("Torre Aprimorada! (+Dano, +Cadência)", Color(1.0, 0.85, 0.25))
		print("[TowerBuilder] Upgrade aplicado na torre na célula ", cell, " por ", upgrade_cost, " créditos. Saldo: ", GameManager.recursos_globais)

func _try_build_tower() -> void:
	if tower_scene == null:
		push_warning("TowerBuilder: Nenhuma cena de torre (tower_scene) configurada no Inspector!")
		return
	
	var mouse_pos: Vector2 = get_global_mouse_position()
	
	# 1. Se houver TileMap, faz a conversão da posição global do mouse para coordenadas do mapa
	var cell: Vector2i = Vector2i.ZERO
	var spawn_pos: Vector2 = mouse_pos
	
	if tilemap != null:
		var local_mouse: Vector2 = tilemap.to_local(mouse_pos)
		cell = tilemap.local_to_map(local_mouse)
		
		# Se a célula clicada já possui uma torre, executa a tentativa de upgrade
		if occupied_cells.has(cell):
			_try_upgrade_tower(cell)
			return
		
		# 2. Verifica se a célula é válida para construção
		if not is_cell_valid_for_building(cell):
			return
		
		# 3. Posiciona a torre exatamente no centro da célula usando map_to_local()
		var local_center: Vector2 = tilemap.map_to_local(cell)
		spawn_pos = tilemap.to_global(local_center)
	
	# 4. Verifica se o jogador possui recursos suficientes no GameManager
	if not GameManager.possui_recursos(tower_cost):
		AudioManager.tocar_erro()
		NotificationManager.enviar_mensagem("Recursos insuficientes! (Custo: %d)" % tower_cost, Color(1.0, 0.4, 0.4))
		print("[TowerBuilder] Recursos insuficientes! Custo: ", tower_cost, " | Disponível: ", GameManager.recursos_globais)
		return
	
	# 5. Deduz o valor chamando a função apropriada do GameManager
	if not GameManager.gastar_recursos(tower_cost):
		return
	
	# 6. Instancia a torre e posiciona no centro da célula
	var tower = tower_scene.instantiate() as Node2D
	add_child(tower)
	tower.global_position = spawn_pos
	AudioManager.tocar_sfx(SFX_TOWER_PLACED)
	
	# 7. Registra a célula em occupied_cells para evitar sobreposição
	if tilemap != null:
		occupied_cells[cell] = tower
		# Libera a coordenada caso a torre seja destruída ou vendida futuramente
		tower.tree_exited.connect(func(): occupied_cells.erase(cell))
		NotificationManager.enviar_mensagem("Torre construída!", Color(0.3, 0.9, 0.5))
		print("[TowerBuilder] Torre construída na célula ", cell, " (Posição: ", spawn_pos, ") | Saldo restante: ", GameManager.recursos_globais)
	else:
		NotificationManager.enviar_mensagem("Torre construída!", Color(0.3, 0.9, 0.5))
		print("[TowerBuilder] Torre construída em: ", spawn_pos, " | Saldo restante: ", GameManager.recursos_globais)

## Valida se a célula pode receber uma construção:
## - Não pode estar no dicionário path_cells (caminho dos inimigos).
## - Não pode estar no dicionário occupied_cells (torre já existe).
## - Se houver dados de tile e a propriedade 'buildable' for booleana, deve ser true.
func is_cell_valid_for_building(cell: Vector2i) -> bool:
	# Verifica se a célula faz parte do caminho dos inimigos
	if path_cells.has(cell):
		print("[TowerBuilder] Construção inválida: célula ", cell, " faz parte do caminho dos inimigos!")
		return false
	
	# Verifica se a célula já está ocupada por outra torre
	if occupied_cells.has(cell):
		print("[TowerBuilder] Construção inválida: célula ", cell, " já está ocupada por outra torre!")
		return false
	
	if tilemap == null:
		return true
	
	# Checagem por Custom Data Layer "buildable" no TileSet
	var tile_data: TileData = _get_tile_data(cell)
	if tile_data != null:
		var is_buildable = tile_data.get_custom_data("buildable")
		if typeof(is_buildable) == TYPE_BOOL and not is_buildable:
			print("[TowerBuilder] Construção inválida: o terreno na célula ", cell, " não permite construções ('buildable' = false).")
			return false
	elif require_tile:
		print("[TowerBuilder] Construção inválida: nenhum tile encontrado na célula ", cell, ".")
		return false
	
	return true

## Auxiliar compatível tanto com TileMapLayer (Godot 4.3+) quanto TileMap clássico
func _get_tile_data(cell: Vector2i) -> TileData:
	if tilemap == null:
		return null
	
	if tilemap is TileMapLayer:
		return tilemap.get_cell_tile_data(cell)
	elif tilemap is TileMap:
		return tilemap.get_cell_tile_data(buildable_layer, cell)
	elif tilemap.has_method("get_cell_tile_data"):
		return tilemap.call("get_cell_tile_data", cell)
	
	return null
