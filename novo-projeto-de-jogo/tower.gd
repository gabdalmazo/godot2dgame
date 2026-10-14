class_name Tower
extends Area2D

@export var attack_range: float = 150.0
@export var fire_rate: float = 1.0
@export var projectile_scene: PackedScene
@export var sprite: Sprite2D

const SFX_LASER = preload("res://assets/audio/sfx/laser.ogg")

var current_target: Node2D = null
var fire_timer: Timer

func _ready() -> void:
	if sprite == null:
		sprite = get_node_or_null("Sprite2D")
		
	# Cria e ajusta dinamicamente o CollisionShape2D baseado no attack_range
	var collision_shape = CollisionShape2D.new()
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = attack_range
	collision_shape.shape = circle_shape
	add_child(collision_shape)
	
	# Configura o Timer de cadência de tiro
	fire_timer = Timer.new()
	fire_timer.wait_time = fire_rate
	fire_timer.autostart = true
	fire_timer.timeout.connect(_on_fire_timer_timeout)
	add_child(fire_timer)
	
	# Conecta os sinais da Area2D para detecção
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	# Garantir que o alvo não tenha sido destruído antes de tentar acessá-lo
	if current_target != null and not is_instance_valid(current_target):
		current_target = null
		_find_new_target()
	
	# Atualiza o visual da torre caso haja um alvo válido
	if current_target != null and is_instance_valid(current_target):
		atualizar_visual_mira(current_target.global_position)

func atualizar_visual_mira(alvo_pos: Vector2) -> void:
	if sprite == null:
		return
		
	var direcao: Vector2 = alvo_pos - global_position
	if direcao == Vector2.ZERO:
		return
		
	# Converte o vetor em ângulo e normaliza no intervalo de 0 a 360 graus
	var angulo_graus: float = wrapf(rad_to_deg(direcao.angle()), 0.0, 360.0)
	
	# Fatiamento matemático em 8 partes de 45 graus cada:
	# 0 = Direita (0°)
	# 1 = Baixo-Direita (45°)
	# 2 = Baixo (90°)
	# 3 = Baixo-Esquerda (135°)
	# 4 = Esquerda (180°)
	# 5 = Cima-Esquerda (225°)
	# 6 = Cima (270°)
	# 7 = Cima-Direita (315°)
	var frame_calculado: int = int(round(angulo_graus / 45.0)) % 8
	
	sprite.frame = frame_calculado

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if current_target == null:
			current_target = body

func _on_body_exited(body: Node2D) -> void:
	if body == current_target:
		current_target = null
		_find_new_target()

func _find_new_target() -> void:
	# Varre corpos na área para buscar o próximo alvo caso o atual saia ou morra
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemy"):
			current_target = body
			return

func _on_fire_timer_timeout() -> void:
	if current_target != null and is_instance_valid(current_target):
		shoot()

func shoot() -> void:
	if projectile_scene == null:
		push_warning("Cena do projétil não configurada na torre!")
		return
		
	var projectile = projectile_scene.instantiate() as Node2D
	
	# Define a posição inicial e aponta na direção do alvo antes de adicionar à cena,
	# permitindo que o _ready() do projétil capture a direção correta e defina o frame 8-way.
	projectile.global_position = global_position
	projectile.look_at(current_target.global_position)
	
	# Instancia o projétil na cena principal para que não herde movimentos da torre
	get_tree().current_scene.add_child(projectile)
	AudioManager.tocar_sfx(SFX_LASER, -3.0)
