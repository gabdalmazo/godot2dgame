class_name Projectile
extends Area2D

@export var speed: float = 400.0
@export var damage: float = 20.0

# Tempo em segundos antes do projétil se auto destruir
var lifetime: float = 5.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	# Usando o temporizador nativo da árvore para lidar com o lifetime
	var timer = get_tree().create_timer(lifetime)
	timer.timeout.connect(_on_lifetime_timeout)

func _physics_process(delta: float) -> void:
	# Move o projétil para frente na direção em que ele está apontando.
	# transform.x representa o vetor "Frente" (Right) no Godot 2D.
	global_position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	# Como configuramos um nó físico filho no teste anterior, precisamos 
	# verificar se o próprio corpo ou seu parente (PathFollow2D) gerenciam a vida
	if body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
	elif body.get_parent() != null and body.get_parent().has_method("take_damage"):
		body.get_parent().take_damage(damage)
		queue_free()

func _on_lifetime_timeout() -> void:
	queue_free()
