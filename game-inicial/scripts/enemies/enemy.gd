class_name AuroraEnemy
extends PathFollow2D
## One resolution signal prevents reward + escape on the same enemy.

signal resolved(enemy: AuroraEnemy, killed: bool)

@export var data: TDEnemyData
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var health: float = 0.0
var health_multiplier: float = 1.0
var speed_multiplier: float = 1.0
var resolved_once: bool = false
var _slow_multiplier: float = 1.0
var _slow_remaining: float = 0.0
var _walk_time: float = 0.0
var _heading: Vector2 = Vector2.RIGHT
var _direction: StringName = &"e"
var _using_frames: bool = false
var _static_sprite: Sprite2D
var _using_static: bool = false
var _face_left: bool = false


func _ready() -> void:
	if data == null:
		push_error("Enemy requires TDEnemyData.")
		set_process(false)
		return
	loop = false
	rotates = false
	health = data.max_health * health_multiplier
	add_to_group("enemies")
	var static_texture: Texture2D = AuroraVisualAssets.load_texture(data.static_texture_path)
	_using_frames = _has_walk_frames() and (data.prefer_walk_frames or static_texture == null)
	animated_sprite.visible = _using_frames
	if _using_frames:
		animated_sprite.sprite_frames = data.walk_frames
		animated_sprite.scale = data.sprite_scale
		animated_sprite.position = data.sprite_offset
		_update_animation()
	elif static_texture != null:
		_using_static = true
		_static_sprite = Sprite2D.new()
		_static_sprite.name = "StaticArtwork"
		_static_sprite.texture = static_texture
		_static_sprite.centered = false
		_static_sprite.offset = -data.static_pivot
		_static_sprite.scale = Vector2.ONE * data.static_scale
		add_child(_static_sprite)
	z_as_relative = false
	z_index = AuroraVisualAssets.depth_at(position.y)
	queue_redraw()


func _process(delta: float) -> void:
	if resolved_once:
		return
	_slow_remaining = maxf(0.0, _slow_remaining - delta)
	if _slow_remaining <= 0.0:
		_slow_multiplier = 1.0
	var previous_position: Vector2 = position
	progress += data.speed * speed_multiplier * _slow_multiplier * delta
	var displacement: Vector2 = position - previous_position
	if displacement.length_squared() > 0.00001:
		_heading = displacement.normalized()
		if absf(_heading.x) >= absf(_heading.y):
			_direction = &"e" if _heading.x >= 0.0 else &"w"
		else:
			_direction = &"s" if _heading.y >= 0.0 else &"n"
	_walk_time += delta * _slow_multiplier
	if _using_frames:
		_update_animation()
	elif _using_static:
		_update_static_visual()
	z_index = AuroraVisualAssets.depth_at(position.y)
	queue_redraw()
	if progress_ratio >= 1.0:
		_resolve(false)


func take_damage(amount: float) -> void:
	if resolved_once or amount <= 0.0:
		return
	health = maxf(0.0, health - amount * (1.0 - data.damage_reduction))
	queue_redraw()
	if health <= 0.0:
		_resolve(true)


func apply_slow(multiplier: float, duration: float) -> void:
	if resolved_once or duration <= 0.0:
		return
	# Refresh duration and retain the strongest effect, never multiply stacks.
	_slow_multiplier = minf(_slow_multiplier, clampf(multiplier, data.slow_resistance_floor, 1.0))
	_slow_remaining = maxf(_slow_remaining, duration)


func _resolve(killed: bool) -> void:
	if resolved_once:
		return
	resolved_once = true
	remove_from_group("enemies")
	set_process(false)
	resolved.emit(self, killed)
	queue_free()


func _has_walk_frames() -> bool:
	if data.walk_frames == null:
		return false
	for direction in [&"n", &"s", &"e", &"w"]:
		var source: StringName = direction
		if direction == &"e" and data.mirror_east_from_west:
			source = &"w"
		var animation: StringName = StringName("walk_" + String(source))
		if not data.walk_frames.has_animation(animation):
			return false
		if data.walk_frames.get_frame_count(animation) == 0:
			return false
	return true


func _update_animation() -> void:
	var source: StringName = _direction
	animated_sprite.flip_h = _direction == &"e" and data.mirror_east_from_west
	if animated_sprite.flip_h:
		source = &"w"
	animated_sprite.play(StringName("walk_" + String(source)))
	animated_sprite.speed_scale = _slow_multiplier


func _update_static_visual() -> void:
	# Transform only the artwork. Path progress, root position and combat stay unchanged.
	if absf(_heading.x) > 0.2:
		_face_left = _heading.x < 0.0
	var phase: float = _walk_time * data.stride_frequency
	var step: float = sin(phase)
	var facing: float = -1.0 if _face_left else 1.0
	var squash: float = step * data.squash_ratio
	_static_sprite.scale = Vector2(facing * (1.0 - squash), 1.0 + squash) * data.static_scale
	_static_sprite.position = Vector2(step * data.lateral_sway, cos(phase * 2.0) * data.bob_amplitude)
	_static_sprite.rotation = deg_to_rad(data.sway_degrees * step + data.lean_degrees * _heading.x)


func _draw() -> void:
	if data == null:
		return
	var radius: float = data.body_radius
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.0, 0.45))
	draw_circle(Vector2.ZERO, radius + 3.0, Color(0, 0, 0, 0.28))
	draw_set_transform(Vector2.ZERO)
	if data.is_boss and not _using_frames and not _using_static:
		_draw_boss()
	elif not _using_frames and not _using_static:
		var step: float = sin(_walk_time * 9.0) * 0.5
		var center: Vector2 = Vector2(0, -radius - absf(step) * 0.4)
		draw_circle(Vector2(-radius * 0.5, -2 + step), radius * 0.36, Color("173345"))
		draw_circle(Vector2(radius * 0.5, -2 - step), radius * 0.36, Color("173345"))
		if data.is_golem:
			draw_rect(Rect2(center - Vector2(radius, radius), Vector2.ONE * radius * 2), data.body_color)
			draw_colored_polygon(PackedVector2Array([center + Vector2(-8, -12), center + Vector2(-3, -25), center + Vector2(3, -10)]), Color("8befff"))
		else:
			draw_circle(center, radius, data.body_color)
			draw_colored_polygon(PackedVector2Array([center + Vector2(-7, -4), center + Vector2(-19, -13), center + Vector2(-10, 4)]), data.body_color)
			draw_line(center + Vector2(-9, 5), center + Vector2(9, 5), Color("ff8c75"), 4.0)
		# Directional eye/marker follows the curve without rotating the body.
		draw_circle(center + _heading * radius * 0.65, 3.0, Color("fff6cd"))
		draw_circle(center + _heading * radius * 0.78, 1.4, Color("173345"))
	if _slow_remaining > 0.0:
		draw_arc(Vector2(0, -radius), radius + 4, 0, TAU, 24, Color("9ceaff"), 2.0)
	if health < data.max_health * health_multiplier:
		var height: float = maxf(data.visual_height, radius * 2) if data.is_boss or _using_static or _using_frames else radius * 2
		var width: float = data.health_bar_width
		var bar: Vector2 = Vector2(-width * 0.5, -height - 10)
		draw_rect(Rect2(bar, Vector2(width, 5)), Color("162636"))
		draw_rect(Rect2(bar + Vector2.ONE, Vector2((width - 2) * health / (data.max_health * health_multiplier), 3)), Color("91efb5"))


func _draw_boss() -> void:
	# Explicit temporary silhouette until a transparent boss sprite is supplied.
	var r: float = data.body_radius
	var center: Vector2 = Vector2(0, -r - 8)
	draw_colored_polygon(PackedVector2Array([
		center + Vector2(-r, r), center + Vector2(-r * 0.88, -r * 0.72),
		center + Vector2(-r * 0.35, -r * 1.08), center + Vector2(0, -r * 0.65),
		center + Vector2(r * 0.35, -r * 1.08), center + Vector2(r * 0.88, -r * 0.72),
		center + Vector2(r, r)
	]), Color("31435e"))
	draw_colored_polygon(PackedVector2Array([
		center + Vector2(-r * 0.85, -r * 0.55), center + Vector2(-r * 0.52, -r * 1.45),
		center + Vector2(-r * 0.15, -r * 0.7)
	]), Color("88d8ea"))
	draw_colored_polygon(PackedVector2Array([
		center + Vector2(r * 0.85, -r * 0.55), center + Vector2(r * 0.52, -r * 1.45),
		center + Vector2(r * 0.15, -r * 0.7)
	]), Color("88d8ea"))
	draw_circle(center + Vector2(-r * 0.38, -4), 4.0, Color("83f3ff"))
	draw_circle(center + Vector2(r * 0.38, -4), 4.0, Color("83f3ff"))
	draw_arc(center, r + 3.0, PI * 0.08, PI * 0.92, 24, Color("baf1ff"), 3.0)
	if health < data.max_health * health_multiplier * 0.5:
		draw_line(center + Vector2(-4, -r), center + Vector2(8, -9), Color("d9f6ff"), 2.0)
