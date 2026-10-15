class_name WaveManager
extends Node

signal onda_concluida

@export var enemy_scene: PackedScene
@export var spawn_point: Node # Trajeto padrão
@export var spawn_points: Array[Node] = [] # Lista de trajetos caso o mapa possua mais de uma entrada (ex: cima e baixo)
@export var spawn_interval: float = 1.5
@export var base_enemies_per_wave: int = 5
@export var health_scale_factor: float = 0.5 # Aumenta a vida em 50% por onda
@export var hud: HUD # Referência para comunicação com a UI

var current_wave: int = 1
var enemies_spawned_in_wave: int = 0
var enemies_to_spawn: int = 0
var active_enemies: int = 0
var spawn_timer: Timer

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

func _on_iniciar_onda_solicitada() -> void:
	start_wave()

func start_wave() -> void:
	enemies_spawned_in_wave = 0
	active_enemies = 0
	# Aumenta a dificuldade também na quantidade de inimigos (ex: +2 por onda)
	enemies_to_spawn = base_enemies_per_wave + ((current_wave - 1) * 2)
	
	NotificationManager.enviar_mensagem("Onda %d Iniciada!" % current_wave, Color(0.3, 0.8, 1.0))
	print("--- Iniciando Onda ", current_wave, " --- | Inimigos: ", enemies_to_spawn)
	spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	if enemies_spawned_in_wave < enemies_to_spawn:
		spawn_enemy()
		enemies_spawned_in_wave += 1
	else:
		# Todos os inimigos da onda já nasceram
		spawn_timer.stop()

func spawn_enemy() -> void:
	var target_path: Node = spawn_point
	if not spawn_points.is_empty():
		target_path = spawn_points[enemies_spawned_in_wave % spawn_points.size()]
	
	if enemy_scene == null or target_path == null:
		push_warning("WaveManager: enemy_scene ou caminho de spawn não configurados.")
		return
		
	var enemy = enemy_scene.instantiate()
	
	# Matemática de escalonamento:
	# Onda 1: Multiplicador 1.0 (Vida base)
	# Onda 2: Multiplicador 1.5 (Se health_scale_factor = 0.5)
	# Onda 3: Multiplicador 2.0
	var health_multiplier: float = 1.0 + ((current_wave - 1) * health_scale_factor)
	
	# Aplica o buff na vida base da instância
	enemy.max_health = enemy.max_health * health_multiplier
	
	# Monitora a destruição/derrota do inimigo para saber quando a onda termina por completo
	active_enemies += 1
	enemy.tree_exited.connect(_on_enemy_tree_exited)
	
	# Instancia no mapa. Como o enemy herda de PathFollow2D, o ideal 
	# é que o target seja o próprio nó Path2D da cena.
	target_path.add_child(enemy)

func _on_enemy_tree_exited() -> void:
	active_enemies -= 1
	# Quando todos já foram gerados e não resta nenhum inimigo vivo no mapa
	if enemies_spawned_in_wave >= enemies_to_spawn and active_enemies <= 0:
		end_wave()

func end_wave() -> void:
	NotificationManager.enviar_mensagem("Onda %d Concluída!" % current_wave, Color(1.0, 0.85, 0.2))
	print("Onda ", current_wave, " concluída! Todos os inimigos foram eliminados.")
	current_wave += 1
	# Notifica o HUD de que a onda foi finalizada para liberar o botão
	onda_concluida.emit()
