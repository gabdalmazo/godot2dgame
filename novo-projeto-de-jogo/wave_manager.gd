class_name WaveManager
extends Node

@export var enemy_scene: PackedScene
@export var spawn_point: Node # Trajeto padrão
@export var spawn_points: Array[Node] = [] # Lista de trajetos caso o mapa possua mais de uma entrada (ex: cima e baixo)
@export var spawn_interval: float = 1.5
@export var base_enemies_per_wave: int = 5
@export var health_scale_factor: float = 0.5 # Aumenta a vida em 50% por onda

var current_wave: int = 1
var enemies_spawned_in_wave: int = 0
var enemies_to_spawn: int = 0
var spawn_timer: Timer

func _ready() -> void:
	# Configura o temporizador que controlará o ritmo do spawn
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(spawn_timer)
	
	# Inicia a primeira onda automaticamente para fins de teste
	start_wave()

func start_wave() -> void:
	enemies_spawned_in_wave = 0
	# Aumenta a dificuldade também na quantidade de inimigos (ex: +2 por onda)
	enemies_to_spawn = base_enemies_per_wave + ((current_wave - 1) * 2)
	
	print("--- Iniciando Onda ", current_wave, " --- | Inimigos: ", enemies_to_spawn)
	spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	if enemies_spawned_in_wave < enemies_to_spawn:
		spawn_enemy()
		enemies_spawned_in_wave += 1
	else:
		# Todos os inimigos da onda já nasceram
		spawn_timer.stop()
		end_wave()

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
	
	# Instancia no mapa. Como o enemy herda de PathFollow2D, o ideal 
	# é que o target seja o próprio nó Path2D da cena.
	target_path.add_child(enemy)

func end_wave() -> void:
	print("Spawn da onda ", current_wave, " finalizado. Preparando próxima...")
	current_wave += 1
	
	# Cria uma breve pausa de descanso de 4 segundos antes de iniciar a próxima onda
	get_tree().create_timer(4.0).timeout.connect(start_wave)
