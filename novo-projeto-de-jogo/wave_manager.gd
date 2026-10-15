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
@export var max_waves: int = 5
@export var health_scale_factor: float = 1.2
@export var speed_scale_factor: float = 1.1
@export var hud: HUD # Referência para comunicação com a UI

var current_wave: int = 1
var enemies_spawned_in_wave: int = 0
var enemies_to_spawn: int = 0
var active_enemies: int = 0
var spawn_timer: Timer
var todas_ondas_geradas: bool = false

func _ready() -> void:
	# Configura o temporizador que controlará o ritmo do spawn
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(spawn_timer)
	
	# Busca o HUD na cena caso não tenha sido atribuído no Inspector
	if hud == null:
		hud = get_node_or_null("../HUD")
		
	# Conecta os sinais de comunicação com o HUD
	if hud != null:
		hud.iniciar_onda_solicitada.connect(_on_iniciar_onda_solicitada)
		onda_concluida.connect(hud._on_onda_concluida)

func _process(_delta: float) -> void:
	# Quando todas as ondas forem instanciadas, verifica a erradicação de todos os inimigos
	if todas_ondas_geradas:
		if get_tree().get_nodes_in_group("enemy").is_empty():
			todas_ondas_geradas = false
			fase_concluida.emit()
			NotificationManager.enviar_mensagem("Todas as ondas superadas! Fase Concluída!", Color(1.0, 0.85, 0.2))
			print("[WaveManager] Todas as ondas foram superadas! Sinal fase_concluida emitido.")
			set_process(false)

func _on_iniciar_onda_solicitada() -> void:
	if current_wave <= max_waves:
		start_wave()

func start_wave() -> void:
	if current_wave > max_waves:
		return
		
	enemies_spawned_in_wave = 0
	active_enemies = 0
	# Aumenta a quantidade de inimigos gradualmente por onda (ex: +2 por onda)
	enemies_to_spawn = base_enemies_per_wave + ((current_wave - 1) * 2)
	
	NotificationManager.enviar_mensagem("Onda %d/%d Iniciada!" % [current_wave, max_waves], Color(0.3, 0.8, 1.0))
	print("--- Iniciando Onda ", current_wave, "/", max_waves, " --- | Inimigos: ", enemies_to_spawn)
	spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	if enemies_spawned_in_wave < enemies_to_spawn:
		spawn_enemy()
		enemies_spawned_in_wave += 1
		
		# Verifica se o último inimigo da última onda máxima acabou de ser instanciado
		if current_wave >= max_waves and enemies_spawned_in_wave >= enemies_to_spawn:
			todas_ondas_geradas = true
			spawn_timer.stop()
	else:
		# Todos os inimigos desta onda já nasceram
		spawn_timer.stop()

func spawn_enemy() -> void:
	var target_path: Node = spawn_point
	if not spawn_points.is_empty():
		target_path = spawn_points[enemies_spawned_in_wave % spawn_points.size()]
	
	var cena_a_instanciar: PackedScene = enemy_scene
	var eh_chefe: bool = (current_wave >= max_waves and enemies_spawned_in_wave == enemies_to_spawn - 1 and boss_scene != null)
	if eh_chefe:
		cena_a_instanciar = boss_scene

	if cena_a_instanciar == null or target_path == null:
		push_warning("WaveManager: Cena de inimigo ou caminho de spawn não configurados.")
		return
		
	var enemy: Node = cena_a_instanciar.instantiate()
	
	# Matemática de escalonamento baseada na onda atual multiplicada pelos fatores:
	# Onda 1: Multiplicador 1.0 (Valores base)
	# Onda 2 em diante: Escalonamento incremental baseado em (current_wave - 1)
	var health_multiplier: float = 1.0 + (float(current_wave - 1) * (health_scale_factor - 1.0))
	var speed_multiplier: float = 1.0 + (float(current_wave - 1) * (speed_scale_factor - 1.0))
	
	# Aplica a nova vida e velocidade na instância do inimigo ANTES de adicioná-la à árvore
	if "max_health" in enemy:
		enemy.max_health *= health_multiplier
	
	if "move_speed" in enemy:
		enemy.move_speed *= speed_multiplier
	elif "speed" in enemy:
		enemy.speed *= speed_multiplier
	
	# Monitora a destruição/derrota do inimigo para saber quando a onda intermediária termina
	active_enemies += 1
	enemy.tree_exited.connect(_on_enemy_tree_exited)
	
	# Adiciona à árvore no nó de trajeto (Path2D)
	target_path.add_child(enemy)

func _on_enemy_tree_exited() -> void:
	active_enemies -= 1
	# Quando todos já foram gerados e não resta nenhum inimigo vivo no mapa nesta onda
	if enemies_spawned_in_wave >= enemies_to_spawn and active_enemies <= 0:
		if current_wave < max_waves:
			end_wave()

func end_wave() -> void:
	NotificationManager.enviar_mensagem("Onda %d Concluída!" % current_wave, Color(1.0, 0.85, 0.2))
	print("Onda ", current_wave, " concluída! Todos os inimigos foram eliminados.")
	current_wave += 1
	
	# Notifica o HUD de que a onda foi finalizada para liberar o botão da próxima onda
	if current_wave <= max_waves:
		onda_concluida.emit()
