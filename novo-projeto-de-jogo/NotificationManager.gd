extends CanvasLayer

## NotificationManager (Autoload / Singleton)
## Gerencia a criação e empilhamento de notificações in-game na interface.

@export var notification_scene: PackedScene = preload("res://NotificationItem.tscn")

@onready var vbox_container: VBoxContainer = $MarginContainer/VBoxContainer

func _ready() -> void:
	# Garante que as notificações continuem sendo processadas mesmo com o jogo pausado
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Dispara uma mensagem de confirmação logo ao carregar o jogo
	enviar_mensagem("Sistema de Notificações Conectado!", Color(0.2, 0.9, 0.5))

func _unhandled_input(event: InputEvent) -> void:
	# Atalho de teste rápido: Pressione 'N' para testar o envio de notificação
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_N:
			enviar_mensagem("Notificação de teste! (Tecla N)", Color(0.3, 0.7, 1.0))

## Cria e adiciona uma nova mensagem à lista de notificações.
## [param texto]: O conteúdo da mensagem a ser exibida.
## [param cor]: A cor da fonte da notificação (padrão: Color.WHITE).
func enviar_mensagem(texto: String, cor: Color = Color.WHITE) -> void:
	var cena: PackedScene = notification_scene
	if cena == null:
		cena = preload("res://NotificationItem.tscn")
	
	if cena == null:
		push_error("NotificationManager: Nenhuma cena de notificação definida.")
		return
	
	var item: Node = cena.instantiate()
	
	# Configura o texto e a cor da mensagem na instância
	if item.has_method("configurar"):
		item.configurar(texto, cor)
	
	# Garante a referência ao VBoxContainer caso chamado antes do _ready()
	if vbox_container == null:
		vbox_container = get_node_or_null("MarginContainer/VBoxContainer") as VBoxContainer
	
	if vbox_container != null:
		vbox_container.add_child(item)
	else:
		push_error("NotificationManager: VBoxContainer não foi encontrado na cena.")
