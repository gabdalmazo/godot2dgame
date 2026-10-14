class_name Enemy
extends PathFollow2D

@export var speed: float = 100.0
@export var max_health: float = 50.0
@export var bounty_value: int = 10
@export var sprite: Sprite2D

const SFX_EXPLOSION = preload("res://assets/audio/sfx/explosion.ogg")

@onready var health_bar: ProgressBar = $HealthBar

var current_health: float
var last_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	rotates = false
	if sprite == null:
		sprite = get_node_or_null("Sprite2D")
		
	current_health = max_health
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = current_health
		
	last_position = global_position

func _physics_process(delta: float) -> void:
	# Move o inimigo ao longo do caminho automaticamente
	progress += speed * delta
	
	# Calcula o vetor de direção do movimento subtraindo a posição anterior da atual
	var direcao: Vector2 = global_position - last_position
	
	# Se houve deslocamento mensurável, mapeia para o frame correspondente
	if direcao.length_squared() > 0.001:
		atualizar_frame_direcao(direcao)
	
	# Atualiza a last_position no final do ciclo
	last_position = global_position

func _process(_delta: float) -> void:
	# TESTE: Pressione Espaço (ui_accept) para causar dano
	if Input.is_action_just_pressed("ui_accept"):
		take_damage(20.0)
		print("Dano recebido! Vida atual: ", current_health)

func atualizar_frame_direcao(direcao: Vector2) -> void:
	if sprite == null:
		return
		
	# Converte a direção do movimento para graus no intervalo [0, 360)
	var angulo_graus: float = wrapf(rad_to_deg(direcao.angle()), 0.0, 360.0)
	
	# Fatiamento em 8 partes de 45 graus cada:
	# 0 = Direita (0°)          4 = Esquerda (180°)
	# 1 = Baixo-Direita (45°)   5 = Cima-Esquerda (225°)
	# 2 = Baixo (90°)           6 = Cima (270°)
	# 3 = Baixo-Esquerda (135°) 7 = Cima-Direita (315°)
	var frame_calculado: int = int(round(angulo_graus / 45.0)) % 8
	
	sprite.frame = frame_calculado

func take_damage(amount: float) -> void:
	current_health -= amount
	if health_bar:
		health_bar.value = current_health
	
	if current_health <= 0:
		die()

func die() -> void:
	AudioManager.tocar_sfx(SFX_EXPLOSION, -4.0)
	# Comunica com o Singleton (Autoload) para adicionar os recursos
	GameManager.adicionar_recursos(bounty_value)
	
	queue_free()
