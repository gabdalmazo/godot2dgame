class_name AuroraAudio
extends Node
## Replace a cue WAV without changing callers. Gameplay never depends on sound.

@export var music_stream: AudioStream
@export var music_volume_db: float = -24.0
@export var sfx_volume_db: float = 0.0

const CUES = [
	&"ui", &"build", &"wave", &"arrow", &"ice", &"arcane", &"impact",
	&"kill", &"escape", &"pause", &"victory", &"defeat", &"bell"
]
const MIN_GAP_MS = {
	&"ui": 45, &"arrow": 85, &"ice": 100, &"arcane": 110,
	&"impact": 75, &"kill": 95
}
const VOLUME_DB = {
	&"ui": -17.0, &"build": -12.0, &"wave": -13.0,
	&"arrow": -19.0, &"ice": -18.0, &"arcane": -18.0,
	&"impact": -22.0, &"kill": -18.0, &"escape": -12.0,
	&"pause": -16.0, &"victory": -12.0, &"defeat": -12.0, &"bell": -9.0
}

var _streams: Dictionary = {}
var _last_played: Dictionary = {}
var _players: Array[AudioStreamPlayer] = []
var _next_player: int = 0
var _music_player: AudioStreamPlayer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for cue in CUES:
		var path: String = "res://assets/audio/prototype/%s.wav" % cue
		var stream: AudioStream = null
		if ResourceLoader.exists(path):
			stream = ResourceLoader.load(path) as AudioStream
		if stream == null:
			push_warning("Audio cue unavailable: %s" % path)
		_streams[cue] = stream
	for index in 8:
		var player: AudioStreamPlayer = AudioStreamPlayer.new()
		player.name = "SFX%d" % index
		add_child(player)
		_players.append(player)
	_music_player = AudioStreamPlayer.new()
	_music_player.name = "Music"
	_music_player.volume_db = music_volume_db
	add_child(_music_player)
	_music_player.finished.connect(_loop_music)
	if music_stream != null:
		if music_stream is AudioStreamWAV:
			var loop: AudioStreamWAV = music_stream as AudioStreamWAV
			loop.loop_begin = 0
			loop.loop_end = roundi(loop.get_length() * float(loop.mix_rate))
			loop.loop_mode = AudioStreamWAV.LOOP_FORWARD
		_music_player.stream = music_stream
		_music_player.play()


func _loop_music() -> void:
	if music_stream != null:
		_music_player.play()


func set_music_paused(value: bool) -> void:
	if is_instance_valid(_music_player):
		_music_player.stream_paused = value


func play_cue(cue: StringName) -> void:
	var stream: AudioStream = _streams.get(cue) as AudioStream
	if stream == null:
		return
	var now: int = Time.get_ticks_msec()
	if now - int(_last_played.get(cue, -100000)) < int(MIN_GAP_MS.get(cue, 0)):
		return
	_last_played[cue] = now
	var player: AudioStreamPlayer = _players[_next_player]
	for offset in _players.size():
		var candidate_index: int = (_next_player + offset) % _players.size()
		if not _players[candidate_index].playing:
			player = _players[candidate_index]
			_next_player = (candidate_index + 1) % _players.size()
			break
	if player.playing:
		_next_player = (_next_player + 1) % _players.size()
	player.stop()
	player.stream = stream
	player.volume_db = float(VOLUME_DB.get(cue, -16.0)) + sfx_volume_db
	player.play()
