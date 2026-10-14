class_name MainMenu
extends Control

## Menu Principal do Tower Defense.
## Gerencia a navegação inicial para a seleção de níveis e o encerramento do jogo.

@export var level_select_scene: String = "res://LevelSelect.tscn"
@export var options_scene: String = "res://OptionsMenu.tscn"

@export_group("Referências de UI")
@export var play_button: Button
@export var options_button: Button
@export var quit_button: Button

func _ready() -> void:
	# Resolução automática de referências caso não tenham sido vinculadas no Inspector
	if play_button == null:
		play_button = get_node_or_null("%PlayButton") as Button
	if play_button == null:
		play_button = find_child("PlayButton", true, false) as Button
		
	if options_button == null:
		options_button = get_node_or_null("%OptionsButton") as Button
	if options_button == null:
		options_button = find_child("OptionsButton", true, false) as Button

	if quit_button == null:
		quit_button = get_node_or_null("%QuitButton") as Button
	if quit_button == null:
		quit_button = find_child("QuitButton", true, false) as Button
		
	# Conexão dos sinais de clique dos botões
	if play_button != null:
		play_button.pressed.connect(_on_play_button_pressed)
	else:
		push_warning("[MainMenu] Botão 'Jogar' não encontrado na árvore de nós!")
		
	if options_button != null:
		options_button.pressed.connect(_on_options_button_pressed)
	else:
		push_warning("[MainMenu] Botão 'Opções' não encontrado na árvore de nós!")

	if quit_button != null:
		quit_button.pressed.connect(_on_quit_button_pressed)
	else:
		push_warning("[MainMenu] Botão 'Sair' não encontrado na árvore de nós!")

func _on_play_button_pressed() -> void:
	if level_select_scene.is_empty():
		push_error("[MainMenu] O caminho da cena de seleção de níveis está vazio!")
		return
		
	var err: Error = get_tree().change_scene_to_file(level_select_scene)
	if err != OK:
		push_error("[MainMenu] Falha ao carregar a cena '%s' (Erro: %d)" % [level_select_scene, err])

func _on_options_button_pressed() -> void:
	if options_scene.is_empty():
		push_error("[MainMenu] O caminho da cena de opções está vazio!")
		return
		
	var err: Error = get_tree().change_scene_to_file(options_scene)
	if err != OK:
		push_error("[MainMenu] Falha ao carregar a cena '%s' (Erro: %d)" % [options_scene, err])

func _on_quit_button_pressed() -> void:
	get_tree().quit()
