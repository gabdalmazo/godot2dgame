extends Node

signal recursos_atualizados(novo_valor: int)
signal vida_atualizada(nova_vida: int)
signal game_over

var recursos_globais: int = 100
var vida_jogador: int = 20

func _unhandled_input(event: InputEvent) -> void:
	# TESTE RÁPIDO: Pressione 'K' para simular derrota e testar o Game Over imediatamente
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_K:
			print("[DEBUG] Tecla K pressionada: Causando dano fatal para testar Game Over.")
			sofrer_dano(vida_jogador)

func adicionar_recursos(valor: int) -> void:
	recursos_globais += valor
	recursos_atualizados.emit(recursos_globais)
	
	# Opcional: print para confirmar no console durante testes
	print("Recursos Totais: ", recursos_globais)

func gastar_recursos(valor: int) -> bool:
	if possui_recursos(valor):
		recursos_globais -= valor
		recursos_atualizados.emit(recursos_globais)
		print("Recursos Gastos: ", valor, " | Recursos Restantes: ", recursos_globais)
		return true
	return false

func possui_recursos(valor: int) -> bool:
	return recursos_globais >= valor

func sofrer_dano(quantidade: int) -> void:
	if vida_jogador <= 0:
		return
	
	vida_jogador = max(0, vida_jogador - quantidade)
	vida_atualizada.emit(vida_jogador)
	print("Vida do Jogador: ", vida_jogador)
	
	if vida_jogador <= 0:
		game_over.emit()
		print("GAME OVER: A base foi destruída!")

func reiniciar_jogo() -> void:
	vida_jogador = 20
	recursos_globais = 100
	vida_atualizada.emit(vida_jogador)
	recursos_atualizados.emit(recursos_globais)
	get_tree().paused = false
	get_tree().reload_current_scene()
