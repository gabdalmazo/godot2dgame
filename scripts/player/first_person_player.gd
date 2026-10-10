class_name FirstPersonPlayer
extends CharacterBody3D

@export_group("Movement")
@export_range(0.1, 20.0, 0.1, "or_greater", "suffix:m/s") var walk_speed: float = 3.0
@export_range(0.1, 20.0, 0.1, "or_greater", "suffix:m/s") var run_speed: float = 5.5
@export_range(0.1, 60.0, 0.1, "or_greater", "suffix:m/s²") var acceleration: float = 14.0
@export_range(0.1, 60.0, 0.1, "or_greater", "suffix:m/s²") var deceleration: float = 18.0

@export_group("Mouse Look")
## Degrees per screen pixel; independent of render resolution and frame time.
@export_range(0.01, 1.0, 0.01) var mouse_sensitivity: float = 0.12
@export_range(1.0, 89.0, 1.0, "degrees") var pitch_limit: float = 85.0
@export var capture_mouse_on_start: bool = true

@export_group("References")
@export var view_pivot: Node3D

var _input_enabled: bool = false
var _configured: bool = false
var _gravity: float = float(ProjectSettings.get_setting("physics/3d/default_gravity", 9.8))


func _ready() -> void:
	if not is_instance_valid(view_pivot):
		push_error("Player: assign Head to view_pivot in the Inspector.")
		set_physics_process(false)
		set_process_unhandled_input(false)
		return
	for action: StringName in [&"move_forward", &"move_backward", &"move_left", &"move_right", &"sprint", &"pause"]:
		if not InputMap.has_action(action):
			push_error("Player: missing Input Map action: %s" % action)
			set_physics_process(false)
			set_process_unhandled_input(false)
			return
	_configured = true
	set_input_enabled(capture_mouse_on_start)


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_update_horizontal_velocity(delta)
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		set_input_enabled(not _input_enabled)
		get_viewport().set_input_as_handled()
	elif event is InputEventMouseMotion and _input_enabled and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_update_mouse_look(event.screen_relative)


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT and _configured:
		set_input_enabled(false)


## A future pause menu can disable input before pausing the SceneTree and enable it after resuming.
func set_input_enabled(enabled: bool) -> void:
	_input_enabled = enabled and _configured
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if _input_enabled else Input.MOUSE_MODE_VISIBLE
	if not _input_enabled:
		velocity.x = 0.0
		velocity.z = 0.0


func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= _gravity * delta
	elif velocity.y < 0.0:
		velocity.y = 0.0


func _update_horizontal_velocity(delta: float) -> void:
	var input_direction: Vector2 = Vector2.ZERO
	if _input_enabled:
		input_direction = Input.get_vector(&"move_left", &"move_right", &"move_forward", &"move_backward")
	# Only body yaw affects movement; looking up or down cannot make the player fly.
	var direction: Vector3 = global_basis * Vector3(input_direction.x, 0.0, input_direction.y)
	direction.y = 0.0
	direction = direction.normalized() * input_direction.length()
	var speed: float = run_speed if Input.is_action_pressed(&"sprint") else walk_speed
	var target_velocity: Vector3 = direction * speed
	var horizontal_velocity: Vector3 = Vector3(velocity.x, 0.0, velocity.z)
	var rate: float = deceleration if input_direction.is_zero_approx() else acceleration
	horizontal_velocity = horizontal_velocity.move_toward(target_velocity, rate * delta)
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z


func _update_mouse_look(screen_motion: Vector2) -> void:
	rotate_y(deg_to_rad(-screen_motion.x * mouse_sensitivity))
	view_pivot.rotation.x = clampf(
		view_pivot.rotation.x - deg_to_rad(screen_motion.y * mouse_sensitivity),
		deg_to_rad(-pitch_limit),
		deg_to_rad(pitch_limit)
	)

