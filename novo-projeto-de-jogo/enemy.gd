class_name Enemy
extends PathFollow2D

## Constantes de referência base para cálculo determinístico de cada onda
const BASE_SPEED: float = 100.0
const BASE_MAX_HEALTH: float = 50.0

@export var speed: float = BASE_SPEED
@export var max_health: float = BASE_MAX_HEALTH
@export var bounty_value: int = 10
@export var sprite: Sprite2D

## Registra a qual onda este inimigo pertence (permanece imutável durante toda sua vida)
var onda_origem: int = 1

## Alias para speed para total compatibilidade com sistemas que referenciam move_speed
var move_speed: float:
	get:
		return speed
	set(value):
		speed = value

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

## Configura e congela permanentemente os atributos deste inimigo para a sua onda de origem.
## Garante que novos acionamentos de ondas posteriores JAMAIS alterem seus status.
func inicializar_status_onda(num_onda: int, fator_vida: float, fator_velocidade: float) -> void:
	onda_origem = num_onda
	
	var mult_vida: float = 1.0 + (float(onda_origem - 1) * (fator_vida - 1.0))
	var mult_vel: float = 1.0 + (float(onda_origem - 1) * (fator_velocidade - 1.0))
	
	max_health = BASE_MAX_HEALTH * mult_vida
	current_health = max_health
	speed = BASE_SPEED * mult_vel
	
	if health_bar != null:
		health_bar.max_value = max_health
		health_bar.value = current_health
		
	name = "Enemy_Onda%d_%d" % [onda_origem, get_instance_id()]
	print("[Enemy] Inimigo da Onda %d instanciado: Vida: %.1f | Vel: %.1f (Imutável até a morte)" % [onda_origem, max_health, speed])

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
