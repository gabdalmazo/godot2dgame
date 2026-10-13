class_name Projectile
extends Area2D

@export var speed: float = 400.0
@export var damage: float = 20.0
@export var floating_text_scene: PackedScene = preload("res://FloatingText.tscn")
@export var sprite: Sprite2D

# Tempo em segundos antes do projétil se auto destruir
var lifetime: float = 5.0

# Vetor de direção do voo em linha reta
var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	# Usando o temporizador nativo da árvore para lidar com o lifetime
	var timer = get_tree().create_timer(lifetime)
	timer.timeout.connect(_on_lifetime_timeout)
	
	# Garante referência ao Sprite2D caso não tenha sido atribuído via Inspector
	if sprite == null:
		sprite = get_node_or_null("Sprite2D")
	
	# Captura o vetor de direção do movimento atual do projétil
	var direcao_movimento: Vector2 = transform.x.normalized()
	if direcao_movimento != Vector2.ZERO:
		direction = direcao_movimento
	elif direction == Vector2.ZERO:
		direction = Vector2.RIGHT
	
	# Remove qualquer rotação do nó raiz
	rotation = 0.0
	
	# Converte esse vetor em um ângulo e normaliza no intervalo de 0 a 360 graus
	var angulo_graus: float = wrapf(rad_to_deg(direction.angle()), 0.0, 360.0)
	
	# Mapeamento matemático: fatiando o círculo em 8 direções de 45 graus:
	# 0 = Direita (0°)
	# 1 = Baixo-Direita (45°)
	# 2 = Baixo (90°)
	# 3 = Baixo-Esquerda (135°)
	# 4 = Esquerda (180°)
	# 5 = Cima-Esquerda (225°)
	# 6 = Cima (270°)
	# 7 = Cima-Direita (315°)
	var frame_calculado: int = int(round(angulo_graus / 45.0)) % 8
	
	# Define o frame correto correspondente à direção do voo
	if sprite != null:
		sprite.frame = frame_calculado

func _physics_process(delta: float) -> void:
	# Move o projétil em linha reta constante na direção capturada no _ready()
	global_position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	# Como configuramos um nó físico filho no teste anterior, precisamos 
	# verificar se o próprio corpo ou seu parente (PathFollow2D) gerenciam a vida
	var hit: bool = false
	
	if body.has_method("take_damage"):
		body.take_damage(damage)
		hit = true
	elif body.get_parent() != null and body.get_parent().has_method("take_damage"):
		body.get_parent().take_damage(damage)
		hit = true
	
	if hit:
		_spawn_floating_text(global_position, damage)
		queue_free()

func _spawn_floating_text(pos: Vector2, amount: float) -> void:
	if floating_text_scene == null:
		return
	var text_instance = floating_text_scene.instantiate()
	if text_instance:
		var target_scene = get_tree().current_scene
		if target_scene == null:
			target_scene = get_tree().root
		target_scene.add_child(text_instance)
		if text_instance.has_method("iniciar"):
			text_instance.iniciar(int(amount), pos)

func _on_lifetime_timeout() -> void:
	queue_free()
