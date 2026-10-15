class_name NotificationItem
extends Control

var _texto: String = ""
var _cor: Color = Color.WHITE

func _ready() -> void:
	# Aplica as configurações visuais caso tenham sido injetadas antes do _ready()
	_atualizar_visual()
	_iniciar_animacao()

## Configura o texto e a cor da fonte da notificação.
## Pode ser chamado antes ou após o nó ser adicionado à SceneTree.
func configurar(texto: String, cor: Color = Color.WHITE) -> void:
	_texto = texto
	_cor = cor
	_atualizar_visual()

## Cria a animação puramente via código utilizando Tween:
## 1. Permanece 100% visível por 3 segundos
## 2. Esmaece a opacidade (modulate:a) de 1.0 para 0.0 em 1 segundo
## 3. Ao finalizar, remove o nó da memória com queue_free()
func _iniciar_animacao() -> void:
	# Garante visibilidade total inicial
	modulate.a = 1.0
	
	# Cria o Tween sequencial
	var tween: Tween = create_tween()
	
	# Aguarda 3 segundos com a mensagem visível
	tween.tween_interval(3.0)
	
	# Transiciona o alfa (modulate:a) de 1.0 para 0.0 ao longo de 1 segundo
	tween.tween_property(self, "modulate:a", 0.0, 1.0)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_QUAD)
	
	# Conecta a finalização do Tween à destruição do nó
	tween.finished.connect(queue_free)

## Aplica o texto e cor ao nó Label correspondente
func _atualizar_visual() -> void:
	var label_node: Label = _obter_label()
	if label_node == null:
		return
	
	label_node.text = _texto
	
	# Suporta tanto LabelSettings quanto sobreposição de cor do tema
	if label_node.label_settings != null:
		label_node.label_settings = label_node.label_settings.duplicate()
		label_node.label_settings.font_color = _cor
	else:
		label_node.add_theme_color_override("font_color", _cor)

## Identifica o Label independentemente do script estar anexado em um Label ou PanelContainer
func _obter_label() -> Label:
	var no_atual: Variant = self
	if no_atual is Label:
		return no_atual as Label
	
	# Busca por nó filho direto chamado Label
	var label_direto: Label = get_node_or_null("Label") as Label
	if label_direto != null:
		return label_direto
	
	# Busca recursiva caso esteja dentro de containers intermediários (ex: MarginContainer)
	return find_child("*Label*", true, false) as Label
