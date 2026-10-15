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

var _ultimo_clique_ms: int = 0

func _on_iniciar_onda_btn_pressed() -> void:
	# Debounce de 250ms para prevenir duplo-clique acidental do mouse, mantendo o botão responsivo
	var tempo_atual: int = Time.get_ticks_msec()
	if tempo_atual - _ultimo_clique_ms < 250:
		return
	_ultimo_clique_ms = tempo_atual
	
	# Emite a solicitação de onda sem desativar o botão, permitindo ao jogador
	# acumular múltiplas ondas simultâneas no mapa para maior risco/recompensa.
	iniciar_onda_solicitada.emit()

## Atualiza dinamicamente o texto e disponibilidade do botão de onda
func atualizar_status_onda(ondas_chamadas: int, total_ondas: int) -> void:
	if iniciar_onda_btn == null:
		return
		
	if ondas_chamadas >= total_ondas:
		iniciar_onda_btn.text = "Onda %d/%d (Final)" % [ondas_chamadas, total_ondas]
		iniciar_onda_btn.disabled = true
	else:
		iniciar_onda_btn.text = "Chamar Onda (%d/%d)" % [ondas_chamadas + 1, total_ondas]
		iniciar_onda_btn.disabled = false

func _on_onda_concluida() -> void:
	# Mantido para retrocompatibilidade de sinais
	pass

func _on_vida_atualizada(nova_vida: int) -> void:
	if vida_label:
		vida_label.text = "Vida: %d" % nova_vida

func _on_recursos_atualizados(novo_valor: int) -> void:
	if creditos_label:
		creditos_label.text = "Créditos: %d" % novo_valor
