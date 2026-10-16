class_name TDWaveData
extends Resource

@export var enemy_scenes: Array[PackedScene] = []
@export var counts: Array[int] = []
@export_range(0.1, 10.0) var spawn_interval: float = 1.2


func is_valid() -> bool:
	if enemy_scenes.is_empty() or enemy_scenes.size() != counts.size():
		return false
	for index in enemy_scenes.size():
		if enemy_scenes[index] == null or counts[index] <= 0:
			return false
	return spawn_interval > 0.0


func total_enemies() -> int:
	var total: int = 0
	for count in counts:
		total += count
	return total
