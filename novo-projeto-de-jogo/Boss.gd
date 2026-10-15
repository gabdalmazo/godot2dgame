class_name Boss
extends Enemy

## Script do Chefe (Boss)
## Caminha lentamente até a base com vida altíssima e alta recompensa.
## Pertence aos grupos "boss" e "enemy" para detecção de torres e da base.

@export var boss_name: String = "Giga Invasor"

func _init() -> void:
	# Define status extremos padrão para o Chefe
	speed = 35.0
	max_health = 800.0
	bounty_value = 150

func _ready() -> void:
	# Garante que o nó raiz e o corpo de colisão estejam nos grupos corretos
	add_to_group("boss")
	add_to_group("enemy")
	
	var collision_body: Node = get_node_or_null("EnemyBody")
	if collision_body != null:
		collision_body.add_to_group("boss")
		collision_body.add_to_group("enemy")
		
	# Inicializa a vida e referências visuais da classe base Enemy
	super._ready()
	
	# Emite alerta dramático de chegada do Chefe
	NotificationManager.enviar_mensagem("ALERTA: %s detectado no caminho!" % boss_name, Color(1.0, 0.2, 0.2))

## Recompensa isolada: caso o jogador destrua o chefe antes de chegar à base,
## concede uma recompensa massiva em créditos e notifica a vitória.
func die() -> void:
	NotificationManager.enviar_mensagem("CHEFE DERROTADO! +%d Créditos!" % bounty_value, Color(1.0, 0.85, 0.2))
	print("[Boss] Chefe destruído! Recompensa concedida: ", bounty_value)
	super.die()
