class_name AuroraBellPulse
extends Node2D
## A visual wave from the bell. Enemy slow is applied immediately by the level.

const DURATION: float = 0.85
const MAX_RADIUS: float = 1050.0
var _age: float = -1.0


func _ready() -> void:
	set_process(false)


func trigger() -> void:
	_age = 0.0
	set_process(true)
	queue_redraw()


func _process(delta: float) -> void:
	_age += delta
	if _age >= DURATION:
		_age = -1.0
		set_process(false)
	queue_redraw()


func _draw() -> void:
	if _age < 0.0:
		return
	var phase: float = _age / DURATION
	var alpha: float = 0.5 * (1.0 - phase)
	draw_arc(Vector2.ZERO, maxf(1.0, MAX_RADIUS * phase), 0.0, TAU, 100, Color(0.65, 0.94, 1.0, alpha), 4.0)
	draw_circle(Vector2.ZERO, 18.0 + 34.0 * phase, Color(0.75, 0.97, 1.0, alpha * 0.38))
