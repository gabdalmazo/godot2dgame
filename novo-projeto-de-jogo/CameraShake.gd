class_name CameraShake
extends Camera2D

## Script de Game Feel para vibração / tremor de tela (Screen Shake) puramente matemático.
## Manipula exclusivamente a propriedade 'offset' para preservar a posição/alinhamento original da câmera.

@export_group("Configurações de Tremor")
## Força máxima de deslocamento em pixels gerada pelo tremor.
@export var forca_maxima: float = 15.0

## Velocidade com que o tremor decai de volta a zero a cada frame.
@export var taxa_decaimento: float = 5.0

## Força atual do tremor aplicada no frame (decai continuamente até 0.0).
var forca_atual: float = 0.0

## Armazena a vida anterior para detectar quando o jogador realmente sofre dano.
var vida_anterior: int = 20

func _ready() -> void:
	# Inicializa o valor de vida anterior com o estado atual do GameManager
	if GameManager != null:
		vida_anterior = GameManager.vida_jogador
		if not GameManager.vida_atualizada.is_connected(_on_vida_atualizada):
			GameManager.vida_atualizada.connect(_on_vida_atualizada)

func _process(delta: float) -> void:
	if forca_atual > 0.05:
		# Gera um deslocamento aleatório na propriedade 'offset' baseado na forca_atual
		offset = Vector2(
			randf_range(-forca_atual, forca_atual),
			randf_range(-forca_atual, forca_atual)
		)
		
		# Decaimento suave e exponencial até 0 usando lerp()
		forca_atual = lerp(forca_atual, 0.0, clampf(taxa_decaimento * delta, 0.0, 1.0))
	elif offset != Vector2.ZERO or forca_atual != 0.0:
		# Estabiliza perfeitamente o offset na posição neutra original
		forca_atual = 0.0
		offset = Vector2.ZERO

## Função pública para aplicar tremor com intensidade customizada (1.0 = força máxima padrão)
func aplicar_tremor(intensidade: float = 1.0) -> void:
	# Acumula impacto com teto seguro para evitar distorções exageradas
	forca_atual = clampf(forca_atual + forca_maxima * intensidade, 0.0, forca_maxima * 2.0)

## Responde ao sinal emitido pelo GameManager ao sofrer dano
func _on_vida_atualizada(nova_vida: int) -> void:
	# Verifica se houve redução na vida (dano recebido pela base)
	if nova_vida < vida_anterior:
		var dano: int = vida_anterior - nova_vida
		# Proporciona um tremor compatível com o impacto (mínimo de 0.6)
		var intensidade: float = clampf(float(dano) / 2.0, 0.6, 2.0)
		aplicar_tremor(intensidade)
	
	vida_anterior = nova_vida
