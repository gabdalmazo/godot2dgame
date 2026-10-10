extends SceneTree

var _failures: int = 0
var _checks: int = 0


func _initialize() -> void:
	_run.call_deferred()


func _run() -> void:
	var main_path: String = ProjectSettings.get_setting("application/run/main_scene")
	_check(main_path == "res://scenes/world/prototype_2d.tscn", "Default entry point is the 2D room")
	var world: Node2D = load(main_path).instantiate()
	root.add_child(world)
	var player: PlatformerPlayer = world.get_node("Player")
	var camera: Camera2D = player.get_node("Camera2D")
	_check(not _contains_3d(world), "Active scene contains no 3D nodes")
	_check(root.get_camera_2d() == camera, "Player camera is active")
	_check(Input.mouse_mode == Input.MOUSE_MODE_VISIBLE, "2D gameplay does not capture the mouse")
	_check(_has_key(&"move_left", KEY_A) and _has_key(&"move_left", KEY_LEFT), "Left accepts A and left arrow")
	_check(_has_key(&"move_right", KEY_D) and _has_key(&"move_right", KEY_RIGHT), "Right accepts D and right arrow")
	_check(_has_key(&"jump", KEY_SPACE), "Jump accepts Space")
	await _step(45)
	_check(player.is_on_floor() and absf(player.position.y - 500.0) < 0.2, "Gravity settles feet on floor")

	Input.action_press(&"move_right")
	await _step(2)
	_check(player.velocity.x > 0.0 and player.velocity.x < player.move_speed, "Acceleration is gradual")
	await _step(20)
	_check(is_equal_approx(player.velocity.x, player.move_speed), "Right reaches configured speed")
	_check(not player.sprite.flip_h, "Sprite faces right")
	Input.action_release(&"move_right")
	await _step(2)
	_check(player.velocity.x > 0.0 and player.velocity.x < player.move_speed, "Deceleration is gradual")
	await _step(15)
	_check(is_zero_approx(player.velocity.x), "Release stops player")
	Input.action_press(&"move_left")
	await _step(20)
	_check(is_equal_approx(player.velocity.x, -player.move_speed), "Left reaches configured speed")
	_check(player.sprite.flip_h, "Sprite faces left")
	Input.action_release(&"move_left")
	await _step(15)
	_check(player.sprite.flip_h, "Idle preserves facing direction")

	await _place(player, Vector2(160, 500))
	Input.action_press(&"jump")
	await _step(1)
	_check(player.velocity.y < -400.0, "Grounded jump gives upward velocity")
	var highest_y: float = player.position.y
	for frame in range(75):
		await _step(1)
		highest_y = minf(highest_y, player.position.y)
	_check(highest_y < 410.0 and highest_y > 395.0, "Jump height matches configured impulse and gravity")
	_check(player.is_on_floor(), "Holding jump does not bounce on landing")
	Input.action_release(&"jump")
	await _step(2)
	Input.action_press(&"jump")
	await _step(8)
	Input.action_release(&"jump")
	await _step(2)
	var before_second_press: float = player.velocity.y
	Input.action_press(&"jump")
	await _step(2)
	_check(player.velocity.y > before_second_press, "Airborne press cannot double jump")
	Input.action_release(&"jump")
	await _step(60)

	await _place(player, Vector2(320, 500))
	Input.action_press(&"move_right")
	await _step(30)
	_check(player.position.x <= 348.1 and player.is_on_wall(), "Step blocks walking through it")
	Input.action_press(&"jump")
	await _step(14)
	_release_inputs()
	await _step(60)
	_check(player.is_on_floor() and absf(player.position.y - 468.0) < 0.2, "Jump can land on step")

	await _place(player, Vector2(495, 500))
	Input.action_press(&"move_right")
	Input.action_press(&"jump")
	await _step(25)
	_release_inputs()
	await _step(50)
	_check(player.is_on_floor() and absf(player.position.y - 420.0) < 0.2, "First platform is reachable from floor")
	await _place(player, Vector2(680, 420))
	Input.action_press(&"move_right")
	Input.action_press(&"jump")
	await _step(27)
	_release_inputs()
	await _step(50)
	_check(player.is_on_floor() and absf(player.position.y - 340.0) < 0.2, "Elevated platform is reachable from first platform")
	Input.action_press(&"move_right")
	await _step(60)
	_release_inputs()
	await _step(60)
	_check(player.is_on_floor() and absf(player.position.y - 540.0) < 0.2, "Leaving platform falls onto lower floor")
	_check(camera.get_screen_center_position().distance_to(player.global_position + camera.position) < 1.0, "Camera follows player across room")

	await _place(player, Vector2(625, 500))
	Input.action_press(&"jump")
	var hit_ceiling: bool = false
	var highest_under_platform: float = player.position.y
	for frame in range(10):
		await _step(1)
		hit_ceiling = hit_ceiling or player.is_on_ceiling()
		highest_under_platform = minf(highest_under_platform, player.position.y)
	_check(hit_ceiling and highest_under_platform >= 477.8, "Solid platform underside blocks upward motion")
	_release_inputs()
	await _step(40)
	await _place(player, Vector2(60, 500))
	Input.action_press(&"move_left")
	await _step(45)
	_check(player.position.x >= 11.9 and player.is_on_wall(), "Left boundary blocks escape")
	_release_inputs()
	await _place(player, Vector2(2160, 500))
	Input.action_press(&"move_right")
	await _step(45)
	_check(player.position.x <= 2188.1 and player.is_on_wall(), "Right boundary blocks escape")
	_release_inputs()
	world.queue_free()
	await process_frame
	print("2D controller: %d checks, %d failures" % [_checks, _failures])
	quit(1 if _failures else 0)


func _step(frames: int) -> void:
	for frame in range(frames):
		await physics_frame
		await process_frame


func _place(player: PlatformerPlayer, at: Vector2) -> void:
	_release_inputs()
	player.position = at
	player.velocity = Vector2.ZERO
	await _step(3)


func _release_inputs() -> void:
	for action: StringName in [&"move_left", &"move_right", &"jump"]:
		Input.action_release(action)


func _has_key(action: StringName, key: Key) -> bool:
	for event: InputEvent in InputMap.action_get_events(action):
		if event is InputEventKey and event.physical_keycode == key:
			return true
	return false


func _contains_3d(node: Node) -> bool:
	if node is Node3D:
		return true
	for child: Node in node.get_children():
		if _contains_3d(child):
			return true
	return false


func _check(condition: bool, description: String) -> void:
	_checks += 1
	if condition:
		print("PASS: ", description)
	else:
		_failures += 1
		push_error("FAIL: " + description)
