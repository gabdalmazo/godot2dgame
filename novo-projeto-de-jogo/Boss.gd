class_name Boss
extends Enemy

## Script do Chefe (Boss)
## Caminha lentamente até a base com vida altíssima e alta recompensa.
## Pertence aos grupos "boss" e "enemy" para detecção de torres e da base.

const BASE_BOSS_SPEED: float = 35.0
const BASE_BOSS_MAX_HEALTH: float = 800.0

@export var boss_name: String = "Giga Invasor"

func _init() -> void:
	# Define status extremos padrão para o Chefe
	speed = BASE_BOSS_SPEED
	max_health = BASE_BOSS_MAX_HEALTH
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

## Configuração isolada e congelada dos status do Chefe baseados na sua onda de origem
func inicializar_status_onda(num_onda: int, fator_vida: float, fator_velocidade: float) -> void:
	onda_origem = num_onda
	
	var mult_vida: float = 1.0 + (float(onda_origem - 1) * (fator_vida - 1.0))
	var mult_vel: float = 1.0 + (float(onda_origem - 1) * (fator_velocidade - 1.0))
	
	max_health = BASE_BOSS_MAX_HEALTH * mult_vida
	current_health = max_health
	speed = BASE_BOSS_SPEED * mult_vel
	
	if health_bar != null:
		health_bar.max_value = max_health
		health_bar.value = current_health
		
	name = "Boss_Onda%d_%d" % [onda_origem, get_instance_id()]
	print("[Boss] Chefe %s da Onda %d instanciado: Vida: %.1f | Vel: %.1f (Imutável até a morte)" % [boss_name, onda_origem, max_health, speed])

## Recompensa isolada: caso o jogador destrua o chefe antes de chegar à base,
## concede uma recompensa massiva em créditos e notifica a vitória.
func die() -> void:
	NotificationManager.enviar_mensagem("CHEFE DERROTADO! +%d Créditos!" % bounty_value, Color(1.0, 0.85, 0.2))
	print("[Boss] Chefe destruído! Recompensa concedida: ", bounty_value)
	super.die()
