class_name GameOverModal
extends CanvasLayer

## Modal de Game Over
## Exibido automaticamente ao receber o sinal 'game_over' do GameManager.
## Pausa a árvore do jogo mantendo a interface interativa (PROCESS_MODE_ALWAYS).

@onready var restart_button: Button = %RestartButton

func _ready() -> void:
	# Garante que o CanvasLayer e seus elementos de UI respondam mesmo pausado
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# O modal começa oculto
	visible = false
	
	# Conecta ao sinal emitido pelo Singleton GameManager
	GameManager.game_over.connect(_on_game_over)
	
	if restart_button != null:
		restart_button.pressed.connect(_on_restart_button_pressed)

func _on_game_over() -> void:
	visible = true
	get_tree().paused = true

func _on_restart_button_pressed() -> void:
	visible = false
	GameManager.reiniciar_jogo()
