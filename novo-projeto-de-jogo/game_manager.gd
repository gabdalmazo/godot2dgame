extends Node

signal recursos_atualizados(novo_valor: int)

var recursos_globais: int = 100

func adicionar_recursos(valor: int) -> void:
	recursos_globais += valor
	recursos_atualizados.emit(recursos_globais)
	
	# Opcional: print para confirmar no console durante testes
	print("Recursos Totais: ", recursos_globais)
