class_name PlayerBase
extends Area2D

## Script responsável pela Base do Jogador (ponto final do caminho dos inimigos).
## Detecta inimigos que cruzaram o trajeto, reduz a vida do jogador e destrói o inimigo
## sem conceder recompensas/créditos da economia.

@export var dano_recebido: int = 1

func _ready() -> void:
	# Conecta o sinal body_entered caso ainda não esteja conectado via editor
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Verifica se o corpo ou seu nó pai pertence ao grupo "enemy"
	var enemy_entity: Node = null
	
	if body.is_in_group("enemy"):
		# Se o corpo for um nó filho de colisão (ex: CharacterBody2D sob um PathFollow2D/Enemy),
		# precisamos destruir o nó raiz do inimigo que percorre o Path2D.
		if body.get_parent() is Enemy or (body.get_parent() != null and body.get_parent() is PathFollow2D):
			enemy_entity = body.get_parent()
		else:
			enemy_entity = body
	elif body.get_parent() != null and body.get_parent().is_in_group("enemy"):
		enemy_entity = body.get_parent()
	
	if enemy_entity != null:
		# Evita processamento duplicado caso já esteja marcado para exclusão
		if enemy_entity.is_queued_for_deletion():
			return
		
		# Reduz a vida da base no GameManager
		GameManager.sofrer_dano(dano_recebido)
		print("[PlayerBase] Inimigo atingiu a base! Dano: ", dano_recebido, " | Vida restante: ", GameManager.vida_jogador)
		
		# Destrói o inimigo diretamente via queue_free().
		# IMPORTANTE: Não chamamos die() ou take_damage(), garantindo que o inimigo
		# NÃO conceda créditos ou recursos ao atingir a base.
		enemy_entity.queue_free()
