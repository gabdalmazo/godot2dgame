class_name PlatformerPlayer
extends CharacterBody2D

@export_group("Horizontal Movement")
@export_range(1.0, 1000.0, 1.0, "or_greater", "suffix:px/s") var move_speed: float = 220.0
@export_range(1.0, 5000.0, 10.0, "or_greater", "suffix:px/s²") var acceleration: float = 1800.0
@export_range(1.0, 5000.0, 10.0, "or_greater", "suffix:px/s²") var deceleration: float = 2200.0

@export_group("Jump and Gravity")
@export_range(-1200.0, -1.0, 1.0, "suffix:px/s") var jump_velocity: float = -480.0
@export_range(0.1, 5.0, 0.05) var gravity_multiplier: float = 1.2

@export_group("References")
@export var sprite: Sprite2D

var _gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity", 980.0))


func _ready() -> void:
	if not is_instance_valid(sprite):
		push_error("Player2D: assign Visuals/Sprite2D to sprite in the Inspector.")
		set_physics_process(false)
		return
	for action: StringName in [&"move_left", &"move_right", &"jump"]:
		if not InputMap.has_action(action):
			push_error("Player2D: missing Input Map action: %s" % action)
			set_physics_process(false)
			return


func _physics_process(delta: float) -> void:
	var direction: float = Input.get_axis(&"move_left", &"move_right")
	_update_horizontal_velocity(direction, delta)
	_apply_gravity(delta)
	_try_jump()
	move_and_slide()
	_update_facing(direction)


func _update_horizontal_velocity(direction: float, delta: float) -> void:
	var rate: float = deceleration if is_zero_approx(direction) else acceleration
	velocity.x = move_toward(velocity.x, direction * move_speed, rate * delta)


func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += _gravity * gravity_multiplier * delta
	elif velocity.y > 0.0:
		velocity.y = 0.0


func _try_jump() -> void:
	# Only a new press while grounded jumps; holding the button cannot auto-jump.
	if is_on_floor() and Input.is_action_just_pressed(&"jump"):
		velocity.y = jump_velocity


func _update_facing(direction: float) -> void:
	if not is_zero_approx(direction):
		sprite.flip_h = direction < 0.0
