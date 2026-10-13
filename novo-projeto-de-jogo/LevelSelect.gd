class_name LevelSelect
extends Control

## Tela de Seleção de Níveis
## Apresenta as fases em um GridContainer e reseta o GameManager antes de carregar o nível.

@export var level_1_path: String = "res://Level_1.tscn"

@export_group("Referências de UI")
@export var level_1_button: Button
@export var back_button: Button

func _ready() -> void:
	# Busca referências caso não tenham sido vinculadas pelo Inspector
	if level_1_button == null:
		level_1_button = get_node_or_null("%Level1Button") as Button
	if level_1_button == null:
		level_1_button = find_child("Level1Button", true, false) as Button
		
	if back_button == null:
		back_button = get_node_or_null("%BackButton") as Button
	if back_button == null:
		back_button = find_child("BackButton", true, false) as Button
		
	# Conexão dos sinais de clique dos botões
	if level_1_button != null:
		level_1_button.pressed.connect(_on_level_1_pressed)
	else:
		push_warning("[LevelSelect] Botão da Fase 1 não encontrado!")
		
	if back_button != null:
		back_button.pressed.connect(_on_back_pressed)

func _on_level_1_pressed() -> void:
	# Reseta o estado do jogo (vida = 20, recursos = 100) antes de iniciar
	GameManager.resetar_estado(20, 100)
	
	if level_1_path.is_empty():
		push_error("[LevelSelect] O caminho da Fase 1 está vazio!")
		return
		
	var err: Error = get_tree().change_scene_to_file(level_1_path)
	if err != OK:
		push_error("[LevelSelect] Falha ao carregar a cena '%s' (Erro: %d)" % [level_1_path, err])

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu.tscn")
