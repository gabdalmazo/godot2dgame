class_name AuroraImpact
extends Node2D

var tint: Color = Color.WHITE
var radius: float = 20.0
var lifetime: float = 0.0
var texture: Texture2D
const DURATION: float = 0.3


func _process(delta: float) -> void:
	lifetime += delta
	if lifetime >= DURATION:
		queue_free()
	queue_redraw()


func _draw() -> void:
	var phase: float = clampf(lifetime / DURATION, 0, 1)
	var color: Color = Color(tint, 1.0 - phase)
	if texture != null:
		var size: Vector2 = Vector2.ONE * radius * 2.0 * lerpf(0.45, 1.0, phase)
		draw_texture_rect(texture, Rect2(-size * 0.5, size), false, Color(1, 1, 1, 1.0 - phase))
		return
	draw_arc(Vector2.ZERO, maxf(1, radius * phase), 0, TAU, 24, color, 2.0)
	for index in 6:
		var direction: Vector2 = Vector2.from_angle(index * TAU / 6.0)
		draw_line(direction * radius * phase, direction * (radius * phase + 4), color, 2.0)
