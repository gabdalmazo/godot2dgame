extends Node

## AudioManager (Autoload)
## Gerencia a reprodução global de música de fundo (BGM) persistente e efeitos sonoros (SFX).

const DEFAULT_BGM = preload("res://assets/audio/bgm/bgm_neon.ogg")
const SOUND_CLICK = preload("res://assets/audio/ui/click.ogg")
const SOUND_ERROR = preload("res://assets/audio/ui/error.ogg")

var bgm_player: AudioStreamPlayer
## Volume da música de fundo em decibéis (dB).
## -14.0 dB deixa a trilha suave como ambiente, destacando claramente os efeitos sonoros.
var volume_musica_db: float = -14.0

func _ready() -> void:
	# Permite que o áudio e cliques continuem funcionando mesmo com o jogo pausado
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# 1. Instancia o nó AudioStreamPlayer para a música de fundo via código
	bgm_player = AudioStreamPlayer.new()
	bgm_player.name = "BGMPlayer"
	bgm_player.bus = "Master"
	bgm_player.volume_db = volume_musica_db
	bgm_player.process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Garante reprodução contínua (loop) ao término da faixa
	bgm_player.finished.connect(_on_bgm_finished)
	
	# Adiciona à árvore de nós como filho do AudioManager
	add_child(bgm_player)
	
	# 2. Conecta automaticamente o som de clique aos botões de UI que entram em cena
	get_tree().node_added.connect(_on_node_added)
	_conectar_botoes(get_tree().root)
	
	# 3. Inicia a trilha sonora padrão automaticamente no início do jogo
	if DEFAULT_BGM != null:
		tocar_musica(DEFAULT_BGM)

## Toca a música informada com volume ajustado.
## Se a mesma música já estiver tocando, mantém a reprodução contínua sem reiniciar.
func tocar_musica(stream: AudioStream, volume_db: float = -14.0) -> void:
	if stream == null:
		return
	
	volume_musica_db = volume_db
	if bgm_player != null:
		bgm_player.volume_db = volume_musica_db
	
	# Se a música solicitada já está tocando, não reinicia
	if bgm_player.stream == stream and bgm_player.playing:
		return
	
	# Ativa o loop nativo do recurso se suportado (MP3, OGG, WAV)
	_configurar_loop_stream(stream)
	
	bgm_player.stream = stream
	bgm_player.play()

## Permite alterar o volume da música em tempo de execução
func definir_volume_musica(novo_volume_db: float) -> void:
	volume_musica_db = novo_volume_db
	if bgm_player != null:
		bgm_player.volume_db = volume_musica_db

## Para a reprodução da música de fundo atual
func parar_musica() -> void:
	if bgm_player.playing:
		bgm_player.stop()

## Toca um efeito sonoro (SFX) pontual de forma polifônica (sem cortar outros sons)
func tocar_sfx(stream: AudioStream, volume_db: float = 0.0) -> void:
	if stream == null:
		return
	var sfx_player := AudioStreamPlayer.new()
	sfx_player.stream = stream
	sfx_player.volume_db = volume_db
	sfx_player.bus = "Master"
	sfx_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(sfx_player)
	sfx_player.finished.connect(sfx_player.queue_free)
	sfx_player.play()

## Toca o som de clique padrão de interface
func tocar_click() -> void:
	tocar_sfx(SOUND_CLICK, -2.0)

## Toca o som de ação inválida / erro de interface
func tocar_erro() -> void:
	tocar_sfx(SOUND_ERROR)

func _on_bgm_finished() -> void:
	# Reinicia o áudio automaticamente caso o recurso não tenha loop nativo embutido
	bgm_player.play()

func _configurar_loop_stream(stream: AudioStream) -> void:
	if stream is AudioStreamOggVorbis or stream is AudioStreamMP3:
		stream.loop = true
	elif stream is AudioStreamWAV:
		stream.loop_mode = AudioStreamWAV.LOOP_FORWARD

func _on_node_added(node: Node) -> void:
	if node is BaseButton:
		_vincular_clique(node)

func _conectar_botoes(root_node: Node) -> void:
	if root_node == null:
		return
	if root_node is BaseButton:
		_vincular_clique(root_node)
	for child in root_node.get_children():
		_conectar_botoes(child)

func _vincular_clique(button: BaseButton) -> void:
	if not button.pressed.is_connected(tocar_click):
		button.pressed.connect(tocar_click)
