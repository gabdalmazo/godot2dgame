class_name LevelComplete
extends CanvasLayer

## Tela de Fase Concluída (Vitória)
## Pausa o jogo ao receber o sinal 'fase_concluida' do WaveManager,
## mantendo os botões interativos através do PROCESS_MODE_ALWAYS.

const SFX_VICTORY = preload("res://assets/audio/jingles/victory.ogg")

@export var wave_manager: WaveManager
@export_file("*.tscn") var level_select_scene: String = "res://LevelSelect.tscn"

@onready var action_button: Button = %ActionButton

func _ready() -> void:
	# CRÍTICO: Permite que este CanvasLayer e seus botões continuem
	# processando cliques de mouse e eventos mesmo com o jogo pausado
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# O modal de vitória sempre inicia invisível
	visible = false
	
	# Resolução automática do WaveManager na árvore caso não tenha sido vinculado no Inspector
	if wave_manager == null:
		wave_manager = get_node_or_null("../WaveManager") as WaveManager
	if wave_manager == null and get_parent() != null:
		wave_manager = get_parent().find_child("WaveManager", true, false) as WaveManager
	
	# Conecta o sinal de conclusão emitido pelo WaveManager
	if wave_manager != null and wave_manager.has_signal("fase_concluida"):
		wave_manager.fase_concluida.connect(_on_fase_concluida)
	else:
		push_warning("[LevelComplete] WaveManager não encontrado para escutar o sinal 'fase_concluida'.")
		
	# Resolução e conexão do botão de avanço/retorno
	if action_button == null:
		action_button = find_child("ActionButton", true, false) as Button
	if action_button != null:
		action_button.pressed.connect(_on_action_button_pressed)

## Disparado quando o último inimigo da última onda for derrotado
func _on_fase_concluida() -> void:
	visible = true
	get_tree().paused = true
	
	if SFX_VICTORY != null:
		AudioManager.tocar_sfx(SFX_VICTORY)

## Despausa o jogo e realiza a transição limpa para a Seleção de Níveis
func _on_action_button_pressed() -> void:
	# OBRIGATÓRIO: Despausar a SceneTree antes de carregar uma nova cena,
	# evitando que o menu seguinte inicialize congelado
	get_tree().paused = false
	visible = false
	
	if level_select_scene.is_empty():
		push_error("[LevelComplete] Caminho da cena de seleção de níveis está vazio.")
		return
		
	var err: Error = get_tree().change_scene_to_file(level_select_scene)
	if err != OK:
		push_error("[LevelComplete] Falha ao trocar para a cena '%s' (Erro: %d)" % [level_select_scene, err])
