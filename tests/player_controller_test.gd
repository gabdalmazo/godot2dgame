extends SceneTree

var _failures: int = 0


func _initialize() -> void:
	_run.call_deferred()


func _run() -> void:
	var world: Node3D = load("res://scenes/world/controller_test.tscn").instantiate()
	root.add_child(world)
	var player: FirstPersonPlayer = world.get_node("Player")
	await _step(60)
	_check(player.is_on_floor(), "Spawn settles on floor")
	_check(absf(player.position.y) < 0.02, "Feet rest at floor height")
	player.set_input_enabled(true)
	Input.action_press(&"move_forward")
	await _step(60)
	_check(is_equal_approx(_horizontal_speed(player), player.walk_speed), "Walk reaches configured speed")
	_check(player.position.z < 4.0, "Forward follows negative Z")
	Input.action_press(&"sprint")
	await _step(30)
	_check(is_equal_approx(_horizontal_speed(player), player.run_speed), "Sprint reaches configured speed")
	Input.action_release(&"sprint")
	await _step(30)
	_check(is_equal_approx(_horizontal_speed(player), player.walk_speed), "Releasing sprint returns to walking")
	Input.action_press(&"move_right")
	await _step(30)
	_check(absf(_horizontal_speed(player) - player.walk_speed) < 0.01, "Diagonal speed stays capped")
	Input.action_release(&"move_forward")
	Input.action_release(&"move_right")
	await _step(30)
	_check(_horizontal_speed(player) < 0.001, "Deceleration stops movement")

	_reset(player, Vector3(-8, 0.05, -10))
	Input.action_press(&"move_forward")
	Input.action_press(&"sprint")
	await _step(60)
	_check(player.position.z >= -11.46 and player.is_on_wall(), "Sprinting cannot cross wall")
	var wall_x: float = player.position.x
	Input.action_press(&"move_right")
	await _step(30)
	_check(player.position.x > wall_x + 0.5, "Diagonal motion slides along wall")
	_release_movement()

	_reset(player, Vector3(-3, 0.05, 2))
	Input.action_press(&"move_forward")
	await _step(90)
	_check(player.position.z >= -0.71 and player.is_on_wall(), "Obstacle blocks movement")
	_release_movement()

	_reset(player, Vector3(4, 0.05, 1.3))
	Input.action_press(&"move_forward")
	await _step(70)
	_check(player.position.y > 0.6 and player.is_on_floor(), "Player climbs ramp")
	_release_movement()
	await _step(30)
	var ramp_position: Vector3 = player.position
	await _step(30)
	_check(player.position.distance_to(ramp_position) < 0.02, "Player stays still on slope")
	Input.action_press(&"move_right")
	await _step(70)
	_release_movement()
	await _step(60)
	_check(player.is_on_floor() and absf(player.position.y) < 0.02, "Leaving ramp falls back to floor")

	_reset(player, Vector3(0, 0.05, 6))
	player.rotation.y = PI / 2.0
	player._update_mouse_look(Vector2(0, -100000))
	_check(is_equal_approx(player.view_pivot.rotation.x, deg_to_rad(player.pitch_limit)), "Look up is clamped")
	Input.action_press(&"move_forward")
	await _step(45)
	_check(player.position.x < -1.0 and absf(player.position.z - 6.0) < 0.02, "Walking follows yaw")
	_check(absf(player.position.y) < 0.02, "Camera pitch does not cause flight")
	player._update_mouse_look(Vector2(0, 100000))
	_check(is_equal_approx(player.view_pivot.rotation.x, deg_to_rad(-player.pitch_limit)), "Look down is clamped")
	player.set_input_enabled(false)
	var stopped_position: Vector3 = player.position
	await _step(30)
	_check(player.position.distance_to(stopped_position) < 0.01, "Disabling input stops held movement")
	_check(Input.mouse_mode == Input.MOUSE_MODE_VISIBLE, "Disabling input releases cursor")
	var pause_event: InputEventAction = InputEventAction.new()
	pause_event.action = &"pause"
	pause_event.pressed = true
	player._unhandled_input(pause_event)
	await _step(30)
	_check(player.position.x < stopped_position.x - 0.5, "Pause action restores movement")
	player.notification(Node.NOTIFICATION_APPLICATION_FOCUS_OUT)
	await _step(2)
	_check(_horizontal_speed(player) < 0.001, "Focus loss disables movement")
	_release_movement()

	_reset(player, Vector3(0, 4, 6))
	player.set_input_enabled(false)
	await _step(90)
	_check(player.is_on_floor(), "Gravity continues with input disabled")
	world.queue_free()
	await process_frame
	print("Controller checks finished. Failures: %d" % _failures)
	quit(1 if _failures else 0)


func _step(frames: int) -> void:
	for frame in range(frames):
		await physics_frame
		await process_frame


func _reset(player: FirstPersonPlayer, at: Vector3) -> void:
	player.position = at
	player.rotation = Vector3.ZERO
	player.view_pivot.rotation = Vector3.ZERO
	player.velocity = Vector3.ZERO
	player.set_input_enabled(true)


func _release_movement() -> void:
	for action: StringName in [&"move_forward", &"move_backward", &"move_left", &"move_right", &"sprint"]:
		Input.action_release(action)


func _horizontal_speed(player: FirstPersonPlayer) -> float:
	return Vector2(player.velocity.x, player.velocity.z).length()


func _check(condition: bool, description: String) -> void:
	if condition:
		print("PASS: ", description)
	else:
		_failures += 1
		push_error("FAIL: " + description)
