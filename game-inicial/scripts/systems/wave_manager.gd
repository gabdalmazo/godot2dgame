class_name AuroraWaveManager
extends Node

signal spawn_requested(enemy_scene: PackedScene)
signal spawning_finished

@export var waves: Array[TDWaveData] = []
var wave_index: int = -1
var spawning: bool = false
var _queue: Array[PackedScene] = []
var _elapsed: float = 0.0
var _interval: float = 1.0


func configuration_valid() -> bool:
	if waves.is_empty():
		return false
	for wave in waves:
		if wave == null or not wave.is_valid():
			return false
	return true


func begin_next_wave() -> bool:
	if spawning or wave_index + 1 >= waves.size() or not configuration_valid():
		return false
	wave_index += 1
	var wave: TDWaveData = waves[wave_index]
	_queue.clear()
	# Interleave species so tanks do not all spawn as a separate trailing block.
	var remaining: Array[int] = wave.counts.duplicate()
	var support_total: int = wave.total_enemies() - (1 if wave.has_boss() else 0)
	while _queue.size() < support_total:
		for index in remaining.size():
			if remaining[index] > 0:
				_queue.append(wave.enemy_scenes[index])
				remaining[index] -= 1
	if wave.has_boss():
		_queue.append(wave.boss_scene)
	_interval = wave.spawn_interval
	_elapsed = _interval
	spawning = true
	return true


func _process(delta: float) -> void:
	if not spawning:
		return
	_elapsed += delta
	while spawning and _elapsed >= _interval:
		_elapsed -= _interval
		var scene: PackedScene = _queue.pop_front()
		spawn_requested.emit(scene)
		if _queue.is_empty():
			spawning = false
			spawning_finished.emit()


func stop() -> void:
	spawning = false
	_queue.clear()


func current_wave() -> TDWaveData:
	if wave_index < 0 or wave_index >= waves.size():
		return null
	return waves[wave_index]
