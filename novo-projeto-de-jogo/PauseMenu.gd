class_name PauseMenu
extends CanvasLayer

## Gerenciador de Pausa (Pause Menu)
## Controla o congelamento e descongelamento da SceneTree via get_tree().paused.
## Suporta navegação integrada ao menu de opções de áudio e retorno à partida.

@export_group("Referências de UI")
@export var resume_button: Button
@export var options_button: Button
@export var main_menu_button: Button
@export var pause_panel: Control
@export var options_menu: OptionsMenu

func _ready() -> void:
	# Configuração Crítica: Garante que este nó continue ativo quando o jogo congelar
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Restrição: O menu e o submenu de opções iniciam ocultos
	visible = false
	
	# Resolução defensiva de nós
	if resume_button == null:
		resume_button = get_node_or_null("%ResumeButton") as Button
	if resume_button == null:
		resume_button = find_child("ResumeButton", true, false) as Button
		
	if options_button == null:
		options_button = get_node_or_null("%OptionsButton") as Button
	if options_button == null:
		options_button = find_child("OptionsButton", true, false) as Button

	if main_menu_button == null:
		main_menu_button = get_node_or_null("%MainMenuButton") as Button
	if main_menu_button == null:
		main_menu_button = find_child("MainMenuButton", true, false) as Button

	if pause_panel == null:
		pause_panel = get_node_or_null("CenterContainer") as Control
	if pause_panel == null:
		pause_panel = find_child("CenterContainer", true, false) as Control

	if options_menu == null:
		options_menu = get_node_or_null("OptionsMenu") as OptionsMenu
	if options_menu == null:
		options_menu = find_child("OptionsMenu", true, false) as OptionsMenu

	# Conexão dos sinais dos botões
	if resume_button != null:
		resume_button.pressed.connect(_on_resume_pressed)
	else:
		push_warning("[PauseMenu] Botão 'Retomar' não encontrado!")

	if options_button != null:
		options_button.pressed.connect(_on_options_pressed)
	else:
		push_warning("[PauseMenu] Botão 'Opções' não encontrado!")

	if main_menu_button != null:
		main_menu_button.pressed.connect(_on_main_menu_pressed)

	if options_menu != null:
		options_menu.visible = false
		options_menu.voltar_pressionado.connect(_on_options_closed)

func _unhandled_input(event: InputEvent) -> void:
	# Detecta o pressionar da ação 'ui_cancel' (tecla ESC mapeada no projeto)
	if event.is_action_pressed("ui_cancel") and not event.is_echo():
		# Se a tela de Game Over já estiver na tela, ignora o pause
		var game_over = get_parent().find_child("GameOverModal", true, false)
		if game_over != null and game_over.visible:
			return
		
		# Se o submenu de opções estiver aberto, fecha o submenu e volta para o painel de pausa
		if options_menu != null and options_menu.visible:
			_on_options_closed()
			get_viewport().set_input_as_handled()
			return
		
		alternar_pausa()
		get_viewport().set_input_as_handled()

## Alterne a visibilidade do menu e inverta o valor de get_tree().paused
func alternar_pausa() -> void:
	var novo_estado: bool = not get_tree().paused
	definir_pausa(novo_estado)

## Define o estado de pausa da SceneTree e a visibilidade do menu
func definir_pausa(pausar: bool) -> void:
	visible = pausar
	get_tree().paused = pausar
	
	if not pausar:
		# Ao fechar o menu de pausa, restaura o painel principal e oculta opções
		if options_menu != null:
			options_menu.visible = false
		if pause_panel != null:
			pause_panel.visible = true
	else:
		# Ao abrir o menu de pausa, garante que o painel principal esteja visível
		if options_menu != null:
			options_menu.visible = false
		if pause_panel != null:
			pause_panel.visible = true

func _on_resume_pressed() -> void:
	definir_pausa(false)

func _on_options_pressed() -> void:
	if pause_panel != null:
		pause_panel.visible = false
	if options_menu != null:
		options_menu.visible = true

func _on_options_closed() -> void:
	if options_menu != null:
		options_menu.visible = false
	if pause_panel != null:
		pause_panel.visible = true

func _on_main_menu_pressed() -> void:
	# Despausa a SceneTree antes de trocar de cena para não congelar o Menu Principal
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu.tscn")
