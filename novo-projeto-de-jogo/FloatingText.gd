class_name FloatingText
extends Marker2D

@export var travel_distance: float = 50.0
@export var duration: float = 1.0

@onready var label: Label = $Label

func iniciar(dano: int, posicao_inicial: Vector2) -> void:
	global_position = posicao_inicial
	
	# Garante que o nó filho Label esteja referenciado caso a função seja chamada antes do _ready()
	if label == null:
		label = $Label
	
	label.text = str(dano)
	
	# Caso o nó ainda não tenha sido inserido na árvore (SceneTree), aguarda o ready para criar o Tween com segurança
	if not is_inside_tree():
		await ready
	
	# Garante opacidade inicial total
	modulate.a = 1.0
	
	# Cria o Tween configurado para rodar propriedades em paralelo
	var tween = create_tween().set_parallel(true)
	
	# Animação no eixo Y: move para cima (subtração no eixo Y em 2D) com desaceleração suave
	tween.tween_property(self, "global_position", global_position + Vector2(0, -travel_distance), duration)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_CUBIC)
	
	# Animação de fade-out: reduz modulate:a de 1.0 para 0.0
	tween.tween_property(self, "modulate:a", 0.0, duration)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_CUBIC)
	
	# Ao finalizar a interpolação do Tween, libera o nó da memória
	tween.finished.connect(queue_free)
