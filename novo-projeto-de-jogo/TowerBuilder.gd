class_name TowerBuilder
extends Node2D

## Gerenciador responsável por permitir ao jogador construir torres clicando na tela.
## Detecta cliques do botão esquerdo, valida a economia no GameManager e instancia a torre.

@export var tower_scene: PackedScene
@export var tower_cost: int = 50

func _unhandled_input(event: InputEvent) -> void:
	# Detecta clique com o botão esquerdo do mouse
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_build_tower()

func _build_tower() -> void:
	if tower_scene == null:
		push_warning("TowerBuilder: Nenhuma cena de torre (tower_scene) configurada no Inspector!")
		return
	
	# 1. Verifica se o jogador possui recursos suficientes no GameManager
	if not GameManager.possui_recursos(tower_cost):
		print("Recursos insuficientes! Custo da torre: ", tower_cost, " | Recursos disponíveis: ", GameManager.recursos_globais)
		return
	
	# 2. Deduz o valor chamando a função apropriada do GameManager
	if not GameManager.gastar_recursos(tower_cost):
		return
	
	# 3. Instancia a cena da Torre
	var tower = tower_scene.instantiate() as Node2D
	
	# 4. Adiciona a instância à árvore da cena
	add_child(tower)
	
	# 5. Define a global_position para a posição global do mouse
	tower.global_position = get_global_mouse_position()
	
	print("Torre construída com sucesso em: ", tower.global_position, " | Saldo restante: ", GameManager.recursos_globais)
