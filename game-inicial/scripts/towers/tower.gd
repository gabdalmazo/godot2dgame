class_name AuroraTower
extends Node2D

signal shot(origin: Vector2, target: AuroraEnemy, tower_data: TDTowerData)

@export var data: TDTowerData
var show_range: bool = false
var _cooldown: float = 0.0
var _visual_texture: Texture2D


func _ready() -> void:
	if data == null:
		push_error("Tower requires TDTowerData.")
		set_process(false)
		return
	_visual_texture = data.texture
	if _visual_texture == null:
		_visual_texture = AuroraVisualAssets.load_texture(data.texture_path)
	z_as_relative = false
	z_index = AuroraVisualAssets.depth_at(position.y)
	if _visual_texture != null:
		var visual: Sprite2D = Sprite2D.new()
		visual.name = "TowerArtwork"
		visual.texture = _visual_texture
		visual.scale = data.texture_scale
		visual.position = data.texture_offset
		add_child(visual)
	queue_redraw()


func _process(delta: float) -> void:
	_cooldown = maxf(0.0, _cooldown - delta)
	if _cooldown > 0.0:
		return
	var target: AuroraEnemy = _find_target()
	if target == null:
		# Limit scans while idle; at most seven towers in this prototype.
		_cooldown = 0.1
		return
	_cooldown = data.attack_interval
	shot.emit(to_global(Vector2(0, -32)), target, data)


func _find_target() -> AuroraEnemy:
	var best: AuroraEnemy = null
	var furthest_progress: float = -1.0
	for node in get_tree().get_nodes_in_group("enemies"):
		var enemy: AuroraEnemy = node as AuroraEnemy
		if enemy == null or enemy.resolved_once:
			continue
		if to_local(enemy.global_position).length_squared() > data.attack_range * data.attack_range:
			continue
		if enemy.progress > furthest_progress:
			best = enemy
			furthest_progress = enemy.progress
	return best


func _draw() -> void:
	if data == null:
		return
	if show_range:
		draw_circle(Vector2.ZERO, data.attack_range, Color(data.tint, 0.07))
		draw_arc(Vector2.ZERO, data.attack_range, 0.0, TAU, 64, Color(data.tint, 0.55), 1.0)
	if _visual_texture != null:
		return
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(1, 0.5))
	draw_circle(Vector2.ZERO, 23, Color("203b4b"))
	draw_circle(Vector2(0, -4), 20, Color("adccd1"))
	draw_set_transform(Vector2.ZERO)
	draw_rect(Rect2(-14, -34, 28, 31), Color("4c6978"))
	draw_rect(Rect2(-10, -33, 7, 28), Color("73929c"))
	match data.attack_kind:
		TDTowerData.AttackKind.ARROW:
			draw_colored_polygon(PackedVector2Array([Vector2(-22, -32), Vector2(0, -64), Vector2(22, -32)]), Color("315b60"))
			draw_line(Vector2(-16, -30), Vector2(16, -30), data.tint, 4.0)
			draw_line(Vector2(0, -41), Vector2(0, -19), Color("6b432c"), 5.0)
		TDTowerData.AttackKind.ICE:
			draw_colored_polygon(PackedVector2Array([Vector2(-13, -36), Vector2(1, -69), Vector2(14, -43), Vector2(3, -28)]), data.tint)
			draw_line(Vector2(1, -65), Vector2(3, -32), Color("d8ffff"), 2.0)
		TDTowerData.AttackKind.ARCANE:
			draw_circle(Vector2(0, -45), 14, Color(data.tint, 0.25))
			draw_circle(Vector2(0, -45), 10, data.tint)
			draw_arc(Vector2(0, -45), 17, -0.4, 2.6, 28, Color("f0cf80"), 2.5)
