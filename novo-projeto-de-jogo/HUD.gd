class_name HUD
extends CanvasLayer

@onready var vida_label: Label = $Panel/HBoxContainer/VidaLabel
@onready var creditos_label: Label = $Panel/HBoxContainer/CreditosLabel

func _ready() -> void:
	# Conecta os sinais emitidos pelo Autoload GameManager
	GameManager.vida_atualizada.connect(_on_vida_atualizada)
	GameManager.recursos_atualizados.connect(_on_recursos_atualizados)
	
	# Inicializa os textos buscando os valores iniciais diretamente do GameManager
	_on_vida_atualizada(GameManager.vida_jogador)
	_on_recursos_atualizados(GameManager.recursos_globais)

func _on_vida_atualizada(nova_vida: int) -> void:
	if vida_label:
		vida_label.text = "Vida: %d" % nova_vida

func _on_recursos_atualizados(novo_valor: int) -> void:
	if creditos_label:
		creditos_label.text = "Créditos: %d" % novo_valor
