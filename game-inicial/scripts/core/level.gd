extends Node2D
## The level owns economy and lifecycle; children in World/Waves pause normally.

enum State { PREPARING, WAVE_ACTIVE, INTERMISSION, VICTORY, DEFEAT, PAUSED }

const TOWER_SCENE: PackedScene = preload("res://scenes/towers/tower.tscn")
const PROJECTILE_SCENE: PackedScene = preload("res://scenes/projectiles/projectile.tscn")

@export var starting_coins: int = 170
@export var starting_lives: int = 15
@export var tower_catalog: Array[TDTowerData] = []
@export var debug_route: bool = false

@onready var path: Path2D = $World/EnemyPath
@onready var pads: Node2D = $World/TowerPads
@onready var towers: Node2D = $World/Towers
@onready var projectiles: Node2D = $World/Projectiles
@onready var waves: AuroraWaveManager = $Waves
@onready var hud: AuroraHUD = $HUD/GameHUD

var state: State = State.PREPARING
var coins: int = 0
var lives: int = 0
var _previous_state: State = State.PREPARING
var _selected_pad: AuroraTowerPad
var _living: Dictionary = {}
var _configuration_valid: bool = true


func _ready() -> void:
	get_tree().paused = false
	coins = starting_coins
	lives = starting_lives
	hud.next_wave_requested.connect(_start_wave)
	hud.pause_requested.connect(_toggle_pause)
	hud.restart_requested.connect(_restart)
	hud.build_requested.connect(_buy_tower)
	hud.close_requested.connect(_clear_selection)
	waves.spawn_requested.connect(_spawn_enemy)
	waves.spawning_finished.connect(_check_wave_complete)
	for child in pads.get_children():
		var pad: AuroraTowerPad = child as AuroraTowerPad
		if pad != null:
			pad.selected.connect(_select_pad)
	var route: Line2D = $World/RouteDebug
	route.points = path.curve.get_baked_points()
	route.visible = debug_route
	_configuration_valid = waves.configuration_valid() and tower_catalog.size() == 3
	if not _configuration_valid:
		push_error("Invalid tower catalog or wave configuration.")
		hud.set_message("Configuração incompleta. Consulte Output/Debugger.")
	else:
		hud.set_message("Escolha uma base numerada, construa suas torres e inicie a onda.")
	_refresh_hud()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_toggle_pause()
		get_viewport().set_input_as_handled()


func _can_build() -> bool:
	return _configuration_valid and state in [State.PREPARING, State.WAVE_ACTIVE, State.INTERMISSION]


func _start_wave() -> void:
	if not _configuration_valid or state not in [State.PREPARING, State.INTERMISSION]:
		return
	if not _living.is_empty() or waves.spawning:
		return
	if waves.begin_next_wave():
		state = State.WAVE_ACTIVE
		hud.set_message("Defenda o sino! Você pode construir durante a onda.")
		_refresh_hud()


func _spawn_enemy(scene: PackedScene) -> void:
	if state != State.WAVE_ACTIVE:
		return
	var enemy: AuroraEnemy = scene.instantiate() as AuroraEnemy
	if enemy == null:
		push_error("Wave scene must instantiate AuroraEnemy.")
		return
	enemy.resolved.connect(_on_enemy_resolved)
	_living[enemy.get_instance_id()] = enemy
	path.add_child(enemy)
	_refresh_hud()


func _on_enemy_resolved(enemy: AuroraEnemy, killed: bool) -> void:
	if not _living.has(enemy.get_instance_id()):
		return
	_living.erase(enemy.get_instance_id())
	if killed:
		coins += enemy.data.reward
		var effect: AuroraImpact = AuroraImpact.new()
		effect.position = projectiles.to_local(enemy.global_position)
		effect.tint = enemy.data.body_color
		effect.radius = 24
		projectiles.add_child(effect)
	else:
		lives = maxi(0, lives - enemy.data.escape_damage)
		hud.set_message("Uma criatura alcançou o sino: -%d vida(s)." % enemy.data.escape_damage)
	if lives <= 0:
		_finish(State.DEFEAT)
		return
	_refresh_hud()
	_check_wave_complete()


func _check_wave_complete() -> void:
	if state != State.WAVE_ACTIVE or waves.spawning or not _living.is_empty():
		return
	if waves.wave_index + 1 == waves.waves.size():
		_finish(State.VICTORY)
	else:
		state = State.INTERMISSION
		hud.set_message("Onda concluída. Reforce a defesa e inicie a próxima quando quiser.")
		_refresh_hud()


func _select_pad(pad: AuroraTowerPad) -> void:
	if not _can_build():
		return
	_clear_selection()
	_selected_pad = pad
	pad.set_highlight(true)
	_refresh_selection()


func _clear_selection() -> void:
	if is_instance_valid(_selected_pad):
		_selected_pad.set_highlight(false)
	_selected_pad = null
	hud.close_build_menu()


func _buy_tower(index: int) -> void:
	if not _can_build() or not is_instance_valid(_selected_pad):
		return
	if _selected_pad.is_occupied() or index < 0 or index >= tower_catalog.size():
		return
	var data: TDTowerData = tower_catalog[index]
	if coins < data.cost:
		hud.set_message("Moedas insuficientes para esta torre.")
		return
	var tower: AuroraTower = TOWER_SCENE.instantiate() as AuroraTower
	tower.data = data
	tower.position = towers.to_local(_selected_pad.global_position)
	tower.shot.connect(_on_shot)
	# Synchronous transaction: reserve the pad and debit before adding the node.
	_selected_pad.tower = tower
	coins -= data.cost
	towers.add_child(tower)
	_selected_pad.set_highlight(true)
	hud.set_message("%s construída na base %d." % [data.display_name, _selected_pad.pad_id])
	_refresh_hud()


func _on_shot(origin: Vector2, target: AuroraEnemy, data: TDTowerData) -> void:
	if state != State.WAVE_ACTIVE or not is_instance_valid(target) or target.resolved_once:
		return
	var projectile: AuroraProjectile = PROJECTILE_SCENE.instantiate() as AuroraProjectile
	projectile.position = projectiles.to_local(origin)
	projectile.target = target
	projectile.data = data
	projectiles.add_child(projectile)


func _toggle_pause() -> void:
	if state in [State.VICTORY, State.DEFEAT]:
		return
	if state == State.PAUSED:
		state = _previous_state
		get_tree().paused = false
	else:
		_previous_state = state
		state = State.PAUSED
		get_tree().paused = true
	_refresh_hud()


func _finish(result: State) -> void:
	state = result
	waves.stop()
	_clear_selection()
	get_tree().paused = true
	_refresh_hud()


func _restart() -> void:
	get_tree().paused = false
	var error: Error = get_tree().reload_current_scene()
	if error != OK:
		push_error("Could not reload level: %s" % error_string(error))


func _refresh_hud() -> void:
	var names: Array[String] = ["Preparando", "Onda ativa", "Intervalo", "Vitória", "Derrota", "Pausado"]
	var can_start: bool = _configuration_valid and state in [State.PREPARING, State.INTERMISSION]
	hud.update_status(coins, lives, waves.wave_index + 1, waves.waves.size(), _living.size(), names[state], can_start)
	_refresh_selection()


func _refresh_selection() -> void:
	if not is_instance_valid(_selected_pad):
		return
	if _selected_pad.is_occupied():
		hud.show_tower_info(_selected_pad.pad_id, _selected_pad.tower.data)
	else:
		hud.show_build_menu(_selected_pad.pad_id, tower_catalog, coins, _can_build())
