class_name LevelSelect
extends Control

## Tela de Seleção de Níveis
## Permite ao jogador escolher a fase ou retornar ao Menu Principal.

@export var test_level_scene: String = "res://test_level.tscn"
@export var main_menu_scene: String = "res://MainMenu.tscn"

@onready var level_1_button: Button = %Level1Button
@onready var back_button: Button = %BackButton

func _ready() -> void:
	if level_1_button != null:
		level_1_button.pressed.connect(_on_level_1_button_pressed)
	if back_button != null:
		back_button.pressed.connect(_on_back_button_pressed)

func _on_level_1_button_pressed() -> void:
	get_tree().change_scene_to_file(test_level_scene)

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file(main_menu_scene)
