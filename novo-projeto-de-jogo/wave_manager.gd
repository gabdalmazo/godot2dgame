class_name WaveManager
extends Node

signal onda_concluida
signal fase_concluida

@export var enemy_scene: PackedScene
@export var boss_scene: PackedScene = preload("res://Boss.tscn")
@export var spawn_point: Node # Trajeto padrão
@export var spawn_points: Array[Node] = [] # Lista de trajetos caso o mapa possua mais de uma entrada (ex: cima e baixo)
@export var spawn_interval: float = 1.5
@export var base_enemies_per_wave: int = 5
@export var max_waves: int = 10
@export var health_scale_factor: float = 1.2
@export var speed_scale_factor: float = 1.1
@export var hud: HUD # Referência para comunicação com a UI

var current_wave: int = 0
var total_spawned_count: int = 0
var waves_spawning_active: int = 0
var todas_ondas_geradas: bool = false

func _ready() -> void:
	# Busca o HUD na cena caso não tenha sido atribuído no Inspector
	if hud == null:
		hud = get_node_or_null("../HUD")
		
	# Conecta os sinais de comunicação com o HUD
	if hud != null:
		hud.iniciar_onda_solicitada.connect(_on_iniciar_onda_solicitada)
		onda_concluida.connect(hud._on_onda_concluida)
		if hud.has_method("atualizar_status_onda"):
			hud.atualizar_status_onda(current_wave, max_waves)

func _process(_delta: float) -> void:
	# Quando todas as ondas foram chamadas até o limite máximo e todas as corrotinas terminaram de gerar
	if todas_ondas_geradas and waves_spawning_active <= 0:
		if get_tree().get_nodes_in_group("enemy").is_empty():
			todas_ondas_geradas = false
			fase_concluida.emit()
			NotificationManager.enviar_mensagem("Todas as 10 ondas superadas! Fase Concluída!", Color(1.0, 0.85, 0.2))
			print("[WaveManager] Todas as 10 ondas foram superadas! Sinal fase_concluida emitido.")
			set_process(false)

func _on_iniciar_onda_solicitada() -> void:
	if current_wave < max_waves:
		start_wave()

## Inicia a próxima onda imediatamente, acumulando inimigos no mapa se ondas anteriores ainda estiverem ativas
func start_wave() -> void:
	if current_wave >= max_waves:
		return
		
	current_wave += 1
	var wave_num: int = current_wave
	
	# Atualiza o botão no HUD mantendo-o sempre disponível até atingir max_waves
	if hud != null and hud.has_method("atualizar_status_onda"):
		hud.atualizar_status_onda(current_wave, max_waves)
		
	# Dispara a rotina assíncrona de spawn para esta onda individual
	_iniciar_spawn_onda(wave_num)

## Corrotina responsável pelo spawn dos inimigos de uma onda específica
func _iniciar_spawn_onda(wave_num: int) -> void:
	waves_spawning_active += 1
	var enemies_in_this_wave: int = base_enemies_per_wave + ((wave_num - 1) * 2)
	
	if wave_num >= max_waves:
		NotificationManager.enviar_mensagem("ONDA FINAL %d/%d: 2 CHEFES A CAMINHO!" % [wave_num, max_waves], Color(1.0, 0.15, 0.2))
	else:
		NotificationManager.enviar_mensagem("Onda %d/%d Convocada!" % [wave_num, max_waves], Color(0.3, 0.8, 1.0))
		
	print("--- Convocando Onda ", wave_num, "/", max_waves, " --- | Inimigos: ", enemies_in_this_wave)
	
	for i in range(enemies_in_this_wave):
		if not is_inside_tree():
			return
			
		# Na onda final (10), os dois últimos inimigos a serem gerados serão Chefes (Bosses)
		var is_boss: bool = (wave_num >= max_waves and i >= enemies_in_this_wave - 2 and boss_scene != null)
		_spawn_single_enemy(wave_num, is_boss, i, enemies_in_this_wave)
		
		# Aguarda o intervalo de spawn respeitando a pausa do jogo
		if i < enemies_in_this_wave - 1:
			await get_tree().create_timer(spawn_interval).timeout
			
	waves_spawning_active -= 1
	
	# Quando a onda final terminar de gerar todos os seus inimigos
	if wave_num >= max_waves:
		todas_ondas_geradas = true

## Instancia e configura atributos de um único inimigo baseado no número da sua onda de origem
func _spawn_single_enemy(wave_num: int, is_boss: bool, enemy_index: int = 0, total_wave_enemies: int = 0) -> void:
	var target_path: Node = spawn_point
	if not spawn_points.is_empty():
		target_path = spawn_points[total_spawned_count % spawn_points.size()]
	total_spawned_count += 1
	
	var cena_a_instanciar: PackedScene = boss_scene if is_boss else enemy_scene
	if cena_a_instanciar == null or target_path == null:
		push_warning("WaveManager: Cena de inimigo ou caminho de spawn não configurados.")
		return
		
	var enemy: Node = cena_a_instanciar.instantiate()
	
	# Diferencia o nome dos dois chefes caso seja a onda final
	if is_boss and "boss_name" in enemy and total_wave_enemies > 0:
		if enemy_index == total_wave_enemies - 2:
			enemy.boss_name = "Giga Invasor Alpha"
		else:
			enemy.boss_name = "Giga Invasor Beta"
	
	# Matemática de escalonamento calculada individualmente para a onda deste inimigo
	var health_multiplier: float = 1.0 + (float(wave_num - 1) * (health_scale_factor - 1.0))
	var speed_multiplier: float = 1.0 + (float(wave_num - 1) * (speed_scale_factor - 1.0))
	
	if "max_health" in enemy:
		enemy.max_health *= health_multiplier
	
	if "move_speed" in enemy:
		enemy.move_speed *= speed_multiplier
	elif "speed" in enemy:
		enemy.speed *= speed_multiplier
		
	target_path.add_child(enemy)
