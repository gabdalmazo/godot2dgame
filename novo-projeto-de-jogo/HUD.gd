class_name HUD
extends CanvasLayer

signal iniciar_onda_solicitada

@onready var vida_label: Label = $Panel/HBoxContainer/VidaLabel
@onready var creditos_label: Label = $Panel/HBoxContainer/CreditosLabel
@onready var iniciar_onda_btn: Button = $IniciarOndaButton

func _ready() -> void:
	# Conecta os sinais emitidos pelo Autoload GameManager
	GameManager.vida_atualizada.connect(_on_vida_atualizada)
	GameManager.recursos_atualizados.connect(_on_recursos_atualizados)
	
	# Inicializa os textos buscando os valores iniciais diretamente do GameManager
	_on_vida_atualizada(GameManager.vida_jogador)
	_on_recursos_atualizados(GameManager.recursos_globais)
	
	# Conecta o sinal pressed do botão Iniciar Onda
	if iniciar_onda_btn:
		iniciar_onda_btn.pressed.connect(_on_iniciar_onda_btn_pressed)

func _on_iniciar_onda_btn_pressed() -> void:
	# Emite a solicitação de início da onda e desativa o botão para evitar cliques duplicados
	iniciar_onda_solicitada.emit()
	if iniciar_onda_btn:
		iniciar_onda_btn.disabled = true

func _on_onda_concluida() -> void:
	# Reativa o botão quando a onda atual for finalizada pelo WaveManager
	if iniciar_onda_btn:
		iniciar_onda_btn.disabled = false

func _on_vida_atualizada(nova_vida: int) -> void:
	if vida_label:
		vida_label.text = "Vida: %d" % nova_vida

func _on_recursos_atualizados(novo_valor: int) -> void:
	if creditos_label:
		creditos_label.text = "Créditos: %d" % novo_valor
