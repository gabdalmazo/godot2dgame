class_name AuroraProjectile
extends Node2D

var target: AuroraEnemy
var data: TDTowerData
var _age: float = 0.0
var _spent: bool = false
var _visual_texture: Texture2D
const MAX_LIFETIME: float = 4.0


func _ready() -> void:
	if data == null:
		return
	_visual_texture = AuroraVisualAssets.load_texture(data.projectile_texture_path)
	if _visual_texture != null:
		var visual: Sprite2D = Sprite2D.new()
		visual.name = "ProjectileArtwork"
		visual.texture = _visual_texture
		visual.scale = Vector2.ONE * data.projectile_texture_scale
		visual.rotation_degrees = data.projectile_texture_rotation_degrees
		add_child(visual)


func _process(delta: float) -> void:
	_age += delta
	if _spent or data == null or _age >= MAX_LIFETIME:
		queue_free()
		return
	if not is_instance_valid(target) or target.resolved_once:
		queue_free()
		return
	var destination: Vector2 = (get_parent() as Node2D).to_local(target.global_position)
	# Aim above the feet while keeping combat distances centered on the path.
	destination.y -= target.data.body_radius
	var displacement: Vector2 = destination - position
	rotation = displacement.angle()
	var distance: float = data.projectile_speed * delta
	if displacement.length() <= maxf(distance, 5.0):
		position = destination
		_hit()
	else:
		position += displacement.normalized() * distance
	queue_redraw()


func _hit() -> void:
	if _spent:
		return
	_spent = true
	var center: Vector2 = target.global_position
	if data.splash_radius > 0.0:
		var world_radius: float = data.splash_radius * global_scale.x
		for node in get_tree().get_nodes_in_group("enemies"):
			var enemy: AuroraEnemy = node as AuroraEnemy
			if enemy != null and not enemy.resolved_once:
				if enemy.global_position.distance_squared_to(center) <= world_radius * world_radius:
					enemy.take_damage(data.damage)
	else:
		target.take_damage(data.damage)
		if is_instance_valid(target) and not target.resolved_once:
			target.apply_slow(data.slow_multiplier, data.slow_duration)
	var effect: AuroraImpact = AuroraImpact.new()
	effect.position = position
	effect.tint = data.tint
	effect.radius = maxf(12, data.splash_radius)
	effect.texture = AuroraVisualAssets.load_texture(data.impact_texture_path)
	get_parent().add_child(effect)
	queue_free()


func _draw() -> void:
	if data == null or _visual_texture != null:
		return
	match data.attack_kind:
		TDTowerData.AttackKind.ARROW:
			draw_line(Vector2(-10, 0), Vector2(5, 0), data.tint, 2.0)
			draw_colored_polygon(PackedVector2Array([Vector2(8, 0), Vector2(2, -3), Vector2(2, 3)]), Color("fff0bf"))
		TDTowerData.AttackKind.ICE:
			draw_colored_polygon(PackedVector2Array([Vector2(8, 0), Vector2(0, -5), Vector2(-8, 0), Vector2(0, 5)]), data.tint)
		TDTowerData.AttackKind.ARCANE:
			draw_circle(Vector2.ZERO, 8, Color(data.tint, 0.25))
			draw_circle(Vector2.ZERO, 4, data.tint)
			draw_circle(Vector2(-1, -1), 1.5, Color.WHITE)
