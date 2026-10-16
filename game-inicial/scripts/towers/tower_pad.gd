class_name AuroraTowerPad
extends Area2D

signal selected(pad: AuroraTowerPad)

@export var pad_id: int = 1
var tower: AuroraTower
var highlighted: bool = false
var _hovered: bool = false


func _ready() -> void:
	$Number.text = str(pad_id)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	queue_redraw()


func is_occupied() -> bool:
	return is_instance_valid(tower)


func set_highlight(value: bool) -> void:
	highlighted = value
	queue_redraw()
	if is_occupied():
		tower.show_range = highlighted or _hovered
		tower.queue_redraw()


func _input_event(viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			selected.emit(self)
			viewport.set_input_as_handled()


func _on_mouse_entered() -> void:
	_hovered = true
	set_highlight(highlighted)


func _on_mouse_exited() -> void:
	_hovered = false
	set_highlight(highlighted)


func _draw() -> void:
	var tint: Color = Color("ffe6a2") if highlighted or _hovered else Color("8fe6ed")
	tint.a = 0.95 if highlighted or _hovered else 0.55
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.0, 0.62))
	draw_arc(Vector2.ZERO, 27.0, 0.0, TAU, 48, tint, 2.5)
	if not is_occupied():
		draw_circle(Vector2.ZERO, 24.0, Color(tint, 0.08))
	draw_set_transform(Vector2.ZERO)
