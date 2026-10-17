class_name AuroraFinalBase
extends Node2D
## Temporary damage overlay over the bell tower painted into the map.

var damage_stage: int = 0


func update_integrity(lives: int, maximum: int) -> void:
	var fraction: float = clampf(float(lives) / maxf(float(maximum), 1.0), 0.0, 1.0)
	var next_stage: int = mini(4, floori((1.0 - fraction) * 5.0))
	if next_stage == damage_stage:
		return
	damage_stage = next_stage
	queue_redraw()


func _draw() -> void:
	var glows: Array[Color] = [Color("81efff"), Color("8fdde9"), Color("eacb93"), Color("ed9a71"), Color("dd685f")]
	var glow: Color = glows[damage_stage]
	var doorway: Vector2 = Vector2(-13, -43)
	draw_circle(doorway, 17.0, Color(glow, 0.10))
	draw_arc(doorway, 19.0, PI * 0.12, PI * 0.88, 24, Color(glow, 0.75), 2.0)
	if damage_stage == 0:
		return
	var crack: Color = Color("263345", 0.88)
	draw_polyline(PackedVector2Array([Vector2(-37, -48), Vector2(-29, -43), Vector2(-32, -31), Vector2(-26, -25)]), crack, 2.5)
	if damage_stage >= 2:
		draw_polyline(PackedVector2Array([Vector2(18, -88), Vector2(11, -73), Vector2(16, -60), Vector2(6, -53)]), crack, 3.0)
		draw_line(Vector2(-33, -31), Vector2(-40, -26), crack, 2.0)
	if damage_stage >= 3:
		draw_polyline(PackedVector2Array([Vector2(-50, -81), Vector2(-37, -71), Vector2(-42, -58), Vector2(-29, -43)]), crack, 3.0)
		draw_circle(Vector2(25, -53), 5.0, Color("4b5568", 0.42))
	if damage_stage >= 4:
		draw_circle(doorway, 13.0, Color("272a39", 0.55))
		draw_line(Vector2(-18, -111), Vector2(-8, -98), Color("bfcbd3", 0.62), 4.0)
