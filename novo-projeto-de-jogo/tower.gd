class_name Tower
extends Area2D

@export var attack_range: float = 150.0
@export var fire_rate: float = 1.0
@export var projectile_damage: float = 20.0
@export var is_upgraded: bool = false
@export var projectile_scene: PackedScene
@export var sprite: Sprite2D
@export var som_disparo: AudioStream = preload("res://assets/audio/sfx/laser.ogg")

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var current_target: Node2D = null
var fire_timer: Timer

func _ready() -> void:
	if sprite == null:
		sprite = get_node_or_null("Sprite2D")
		
	if audio_player == null:
		audio_player = get_node_or_null("AudioStreamPlayer2D") as AudioStreamPlayer2D
	if audio_player == null:
		audio_player = AudioStreamPlayer2D.new()
		audio_player.name = "AudioStreamPlayer2D"
		add_child(audio_player)
		
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
	
	# Injeta o dano calibrado da torre no projétil
	if "damage" in projectile:
		projectile.damage = projectile_damage
		
	# Efeito visual no projétil se a torre for melhorada
	if is_upgraded and "sprite" in projectile and projectile.sprite != null:
		projectile.sprite.modulate = Color(1.0, 0.85, 0.25, 1.0)
	
	projectile.global_position = global_position
	projectile.look_at(current_target.global_position)
	
	get_tree().current_scene.add_child(projectile)
	
	# Áudio posicional 2D com variação de pitch (pitch mais alto na torre melhorada)
	if som_disparo != null and audio_player != null:
		audio_player.stream = som_disparo
		audio_player.pitch_scale = randf_range(1.15, 1.35) if is_upgraded else randf_range(0.9, 1.1)
		audio_player.play()

## Aplica o aprimoramento da torre (nível único):
## 1. Define is_upgraded como true
## 2. Dobra o dano do projétil
## 3. Aumenta levemente a cadência de tiro (reduz o tempo de espera do timer)
## 4. Altera o modulate do Sprite2D para tom dourado/neon
func aplicar_upgrade() -> void:
	if is_upgraded:
		return
		
	is_upgraded = true
	projectile_damage *= 2.0
	fire_rate = max(0.1, fire_rate * 0.75) # 25% mais rápido
	
	if fire_timer != null:
		fire_timer.wait_time = fire_rate
		
	if sprite == null:
		sprite = get_node_or_null("Sprite2D")
		
	if sprite != null:
		sprite.modulate = Color(1.0, 0.85, 0.25, 1.0)
