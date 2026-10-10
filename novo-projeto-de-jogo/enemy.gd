class_name Enemy
extends PathFollow2D

@export var speed: float = 100.0
@export var max_health: float = 50.0
@export var bounty_value: int = 10

var current_health: float

func _ready() -> void:
	current_health = max_health

func _process(delta: float) -> void:
	# Move the enemy along the path automatically
	progress += speed * delta
	
	# TESTE: Pressione Espaço (ui_accept) para causar dano
	if Input.is_action_just_pressed("ui_accept"):
		take_damage(20.0)
		print("Dano recebido! Vida atual: ", current_health)

func take_damage(amount: float) -> void:
	current_health -= amount
	
	if current_health <= 0:
		die()

func die() -> void:
	# Aqui futuramente você pode emitir um sinal com o valor de 'bounty_value'
	# para ser coletado pelo GameManager.
	queue_free()
