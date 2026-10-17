class_name AuroraHUD
extends Control

signal next_wave_requested
signal pause_requested
signal restart_requested
signal build_requested(index: int)
signal upgrade_requested
signal close_requested
signal bell_requested
signal ui_interacted

@onready var lives_label: Label = $Top/Row/LivesPlate/Row/Lives
@onready var coins_label: Label = $Top/Row/CoinsPlate/Row/Coins
@onready var wave_label: Label = $Top/Row/WavePlate/Wave
@onready var title_label: Label = $Top/Row/TitlePlate/Title
@onready var state_label: Label = $Bottom/Row/State
@onready var toast: PanelContainer = $Toast
@onready var message: Label = $Toast/Text
@onready var next_wave: Button = $Bottom/Row/NextWave
@onready var bell_button: Button = $Bottom/Row/Bell
@onready var cooldown_bar: ProgressBar = $Bottom/Row/Bell/Cooldown
@onready var pause_button: Button = $Top/Row/Pause
@onready var build_panel: PanelContainer = $BuildPanel
@onready var build_title: Label = $BuildPanel/Column/Heading/Title
@onready var build_details: Label = $BuildPanel/Column/Details
@onready var build_buttons: HBoxContainer = $BuildPanel/Column/Choices
@onready var upgrade_button: Button = $BuildPanel/Column/Upgrade
@onready var overlay: ColorRect = $Overlay
@onready var overlay_title: Label = $Overlay/Card/Column/Title
@onready var overlay_body: Label = $Overlay/Card/Column/Body
@onready var resume: Button = $Overlay/Card/Column/Resume

var _toast_remaining: float = 0.0
var _last_coins: int = -1
var _last_lives: int = -1
var _current_state: String = "Preparando"
var _alive_count: int = 0
var _next_wave_number: int = 1
var _wave_number: int = 0
var _wave_total: int = 5
var _bell_seconds: int = 0
var _bell_ready: bool = false
var _occupied_info: bool = false
var _build_tween: Tween
var _coin_tween: Tween
var _life_tween: Tween


func _ready() -> void:
	_install_theme()
	var click_buttons: Array = [
		next_wave, bell_button, pause_button, upgrade_button, $Bottom/Row/Restart,
		resume, $Overlay/Card/Column/Restart, $BuildPanel/Column/Heading/Close
	]
	for button in build_buttons.get_children():
		click_buttons.append(button as Button)
	for button in click_buttons:
		var clickable: Button = button as Button
		clickable.pressed.connect(_on_ui_click)
	next_wave.pressed.connect(func() -> void: next_wave_requested.emit())
	bell_button.pressed.connect(func() -> void: bell_requested.emit())
	upgrade_button.pressed.connect(func() -> void: upgrade_requested.emit())
	pause_button.pressed.connect(func() -> void: pause_requested.emit())
	$Bottom/Row/Restart.pressed.connect(func() -> void: restart_requested.emit())
	resume.pressed.connect(func() -> void: pause_requested.emit())
	$Overlay/Card/Column/Restart.pressed.connect(func() -> void: restart_requested.emit())
	$BuildPanel/Column/Heading/Close.pressed.connect(func() -> void: close_requested.emit())
	for index in build_buttons.get_child_count():
		var button: Button = build_buttons.get_child(index) as Button
		_decorate_card(button)
		button.pressed.connect(_request_build.bind(index))
		button.mouse_entered.connect(_card_hover.bind(button, true))
		button.mouse_exited.connect(_card_hover.bind(button, false))
		button.resized.connect(_set_card_pivot.bind(button))
	resized.connect(_update_layout)
	_update_layout()
	build_panel.hide()
	toast.hide()
	overlay.hide()


func _process(delta: float) -> void:
	if _toast_remaining <= 0.0:
		return
	_toast_remaining = maxf(0.0, _toast_remaining - delta)
	toast.modulate.a = minf(1.0, _toast_remaining / 0.35)
	if _toast_remaining <= 0.0:
		toast.hide()


func _on_ui_click() -> void:
	ui_interacted.emit()


func _request_build(index: int) -> void:
	build_requested.emit(index)


func update_status(coins: int, lives: int, wave: int, total: int, alive: int, state: String, can_start: bool) -> void:
	_current_state = state
	_alive_count = alive
	_next_wave_number = mini(wave + 1, total)
	_wave_number = wave
	_wave_total = total
	lives_label.text = str(lives)
	coins_label.text = str(coins)
	wave_label.text = "ONDA\n%d / %d" % [wave, total]
	state_label.text = state if size.x < 850.0 else "%s  ·  %d na trilha" % [state, alive]
	next_wave.disabled = not can_start
	next_wave.text = "INICIAR %d" % _next_wave_number if size.x < 850.0 else "INICIAR ONDA %d" % _next_wave_number
	pause_button.disabled = state in ["Vitória", "Derrota"]
	pause_button.tooltip_text = "Retomar · Esc" if state == "Pausado" else "Pausar · Esc"
	overlay.visible = state in ["Pausado", "Vitória", "Derrota"]
	resume.visible = state == "Pausado"
	overlay_title.text = state
	match state:
		"Pausado":
			overlay_body.text = "A defesa está em pausa.\nRetome quando estiver pronto."
		"Vitória":
			overlay_body.text = "O sino continua brilhando.\nCinco ondas superadas · %d vidas restantes." % lives
		"Derrota":
			overlay_body.text = "O inverno alcançou o sino.\nCombine flechas, gelo, magia e o Sino da Aurora."
	if _last_coins >= 0 and _last_coins != coins:
		_pulse_label(coins_label, true)
	if _last_lives >= 0 and _last_lives != lives:
		_pulse_label(lives_label, false)
	_last_coins = coins
	_last_lives = lives


func update_bell(remaining: float, enabled: bool, duration: float, cooldown: float) -> void:
	bell_button.disabled = not enabled or remaining > 0.05
	_bell_seconds = ceili(remaining)
	_bell_ready = enabled and remaining <= 0.05
	bell_button.text = "    SINO  %ds" % _bell_seconds if remaining > 0.05 else ("   SINO" if size.x < 850.0 else "    SINO DA AURORA")
	bell_button.tooltip_text = "Durante a onda, reduz por %.0f s a velocidade dos inimigos presentes. Recarga: %.0f s." % [duration, cooldown]
	cooldown_bar.value = 100.0 * (1.0 - clampf(remaining / maxf(cooldown, 0.01), 0.0, 1.0))
	$Bottom/Row/Bell/Icon.modulate = Color("b6faff") if _bell_ready else Color("a0b2b8")


func set_message(value: String) -> void:
	message.text = value
	_toast_remaining = 3.8
	toast.modulate.a = 1.0
	toast.show()


func show_build_menu(pad_id: int, catalog: Array[TDTowerData], coins: int, allowed: bool) -> void:
	_occupied_info = false
	_open_build_panel()
	build_title.text = "BASE %d  ·  CONSTRUIR" % pad_id
	build_details.text = "Escolha uma defesa para esta posição."
	build_buttons.show()
	upgrade_button.hide()
	for index in build_buttons.get_child_count():
		var button: Button = build_buttons.get_child(index) as Button
		button.show()
		if index >= catalog.size():
			button.disabled = true
			continue
		var data: TDTowerData = catalog[index]
		var card_name: Label = button.get_node("TowerName") as Label
		var card_cost: Label = button.get_node("Cost") as Label
		var card_hint: Label = button.get_node("Hint") as Label
		card_name.text = data.display_name
		card_cost.text = "%d MOEDAS" % data.cost
		card_cost.add_theme_color_override("font_color", Color("e9a39e") if coins < data.cost else Color("ffdc79"))
		card_hint.text = ["Ataque rápido", "Aplica lentidão", "Dano em área"][index]
		var art: TextureRect = button.get_node("Art") as TextureRect
		art.texture = data.texture if data.texture != null else AuroraVisualAssets.load_texture(data.texture_path)
		button.tooltip_text = "%s\nDano %.0f · Alcance %.0f · Intervalo %.2fs" % [data.description, data.damage, data.attack_range, data.attack_interval]
		button.disabled = not allowed or coins < data.cost
		button.modulate = Color.WHITE if not button.disabled else Color("b1a9a0")
	_update_layout()


func show_tower_info(pad_id: int, data: TDTowerData, coins: int, allowed: bool) -> void:
	_occupied_info = true
	_open_build_panel()
	build_title.text = "BASE %d  ·  %s  ·  NÍVEL %d" % [pad_id, data.display_name, data.level]
	build_details.text = "%s\nDano %.0f  ·  Alcance %.0f  ·  Intervalo %.2fs" % [data.description, data.damage, data.attack_range, data.attack_interval]
	build_buttons.hide()
	upgrade_button.show()
	var next_data: TDTowerData = data.next_level
	upgrade_button.disabled = next_data == null or not allowed or coins < next_data.cost
	upgrade_button.text = "NÍVEL MÁXIMO" if next_data == null else "EVOLUIR PARA NÍVEL %d  ·  %d MOEDAS" % [next_data.level, next_data.cost]
	upgrade_button.tooltip_text = "" if next_data == null else next_data.description
	_update_layout()


func set_boss_wave(active: bool) -> void:
	wave_label.text = "CHEFE\n%d / %d" % [_wave_number, _wave_total] if active else "ONDA\n%d / %d" % [_wave_number, _wave_total]
	wave_label.add_theme_color_override("font_color", Color("ffcb9a") if active else Color("e9f8f8"))


func set_base_condition(lives: int, maximum: int) -> void:
	var fraction: float = float(lives) / maxf(float(maximum), 1.0)
	var condition: String = "quase destruída"
	if fraction >= 0.8:
		condition = "íntegra"
	elif fraction >= 0.6:
		condition = "arranhada"
	elif fraction >= 0.4:
		condition = "danificada"
	elif fraction >= 0.2:
		condition = "muito danificada"
	state_label.tooltip_text = "Base final: %s" % condition


func close_build_menu() -> void:
	if _build_tween != null and _build_tween.is_running():
		_build_tween.kill()
	build_panel.hide()
	build_panel.modulate.a = 1.0
	build_panel.scale = Vector2.ONE


func _open_build_panel() -> void:
	if build_panel.visible:
		return
	build_panel.show()
	build_panel.pivot_offset = build_panel.size * 0.5
	build_panel.modulate.a = 0.0
	build_panel.scale = Vector2(0.985, 0.985)
	if _build_tween != null and _build_tween.is_running():
		_build_tween.kill()
	_build_tween = create_tween().set_parallel(true)
	_build_tween.tween_property(build_panel, "modulate:a", 1.0, 0.16)
	_build_tween.tween_property(build_panel, "scale", Vector2.ONE, 0.16)


func _decorate_card(button: Button) -> void:
	var art: TextureRect = TextureRect.new()
	art.name = "Art"
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	art.position = Vector2(6, 8)
	art.size = Vector2(89, 106)
	button.add_child(art)
	var name_label: Label = _card_label("TowerName", 15)
	name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	name_label.offset_top = 14.0
	name_label.offset_bottom = 54.0
	button.add_child(name_label)
	var cost_label: Label = _card_label("Cost", 15)
	cost_label.offset_top = 65.0
	cost_label.offset_bottom = 87.0
	button.add_child(cost_label)
	var hint_label: Label = _card_label("Hint", 12)
	hint_label.offset_top = 92.0
	hint_label.offset_bottom = 112.0
	hint_label.add_theme_color_override("font_color", Color("a8dce5"))
	button.add_child(hint_label)


func _card_label(label_name: String, font_size: int) -> Label:
	var label: Label = Label.new()
	label.name = label_name
	label.anchor_right = 1.0
	label.offset_left = 99.0
	label.offset_right = -8.0
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", font_size)
	return label


func _card_hover(button: Button, hovered: bool) -> void:
	if button.disabled:
		return
	var tween: Tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.025, 1.025) if hovered else Vector2.ONE, 0.10)


func _set_card_pivot(button: Button) -> void:
	button.pivot_offset = button.size * 0.5


func _pulse_label(label: Label, is_coin: bool) -> void:
	var old_tween: Tween = _coin_tween if is_coin else _life_tween
	if old_tween != null and old_tween.is_running():
		old_tween.kill()
	label.modulate = Color.WHITE
	var tween: Tween = create_tween()
	tween.tween_property(label, "modulate", Color("ffdfa4") if is_coin else Color("ffadad"), 0.08)
	tween.tween_property(label, "modulate", Color.WHITE, 0.22)
	if is_coin:
		_coin_tween = tween
	else:
		_life_tween = tween


func _update_layout() -> void:
	var compact: bool = size.x < 850.0
	var narrow: bool = size.x < 780.0
	build_panel.offset_left = -minf(440.0, (size.x - 24.0) * 0.5)
	build_panel.offset_right = -build_panel.offset_left
	build_panel.offset_top = -240.0 if _occupied_info else -302.0
	build_panel.offset_bottom = -80.0
	$Top/Row/WavePlate.custom_minimum_size.x = 104.0 if compact else 145.0
	$Top/Row/TitlePlate.custom_minimum_size.x = 220.0 if compact else 340.0
	$Top/Row/LivesPlate.custom_minimum_size.x = 91.0 if compact else 108.0
	$Top/Row/CoinsPlate.custom_minimum_size.x = 98.0 if compact else 115.0
	$Top/Row/Pause.custom_minimum_size.x = 55.0 if compact else 64.0
	title_label.text = "VALE DA AURORA" if compact else "VALE DO SINO DA AURORA"
	title_label.add_theme_font_size_override("font_size", 14 if compact else 20)
	bell_button.custom_minimum_size.x = 150.0 if compact else 216.0
	next_wave.custom_minimum_size.x = 139.0 if compact else 184.0
	$Bottom/Row/Restart.custom_minimum_size.x = 76.0 if compact else 92.0
	state_label.text = _current_state if compact else "%s  ·  %d na trilha" % [_current_state, _alive_count]
	next_wave.text = "INICIAR %d" % _next_wave_number if compact else "INICIAR ONDA %d" % _next_wave_number
	if _bell_seconds > 0:
		bell_button.text = "   SINO %ds" % _bell_seconds
	else:
		bell_button.text = "   SINO" if compact else "    SINO DA AURORA"
	for button in build_buttons.get_children():
		var card: Button = button as Button
		var card_art: TextureRect = card.get_node("Art") as TextureRect
		card_art.visible = not narrow
		for label_name in ["TowerName", "Cost", "Hint"]:
			var label: Label = card.get_node(label_name) as Label
			label.offset_left = 10.0 if narrow else 99.0
			label.add_theme_font_size_override("font_size", 13 if narrow and label_name == "TowerName" else 12 if label_name == "Hint" else 15)
	toast.offset_left = -minf(340.0, (size.x - 30.0) * 0.5)
	toast.offset_right = -toast.offset_left


func _install_theme() -> void:
	var ui_theme: Theme = Theme.new()
	ui_theme.default_font_size = 16
	ui_theme.set_stylebox("normal", "Button", _box(Color("4d3328"), Color("bd8250"), 9, 9))
	ui_theme.set_stylebox("hover", "Button", _box(Color("67412b"), Color("ffdaa0"), 9, 9))
	ui_theme.set_stylebox("pressed", "Button", _box(Color("32251f"), Color("f0c36c"), 9, 9))
	ui_theme.set_stylebox("disabled", "Button", _box(Color("514842"), Color("7d7068"), 9, 9))
	var focus: StyleBoxFlat = _box(Color.TRANSPARENT, Color("ffe9a6"), 10, 0)
	focus.draw_center = false
	ui_theme.set_stylebox("focus", "Button", focus)
	ui_theme.set_color("font_color", "Label", Color("fff3db"))
	ui_theme.set_color("font_color", "Button", Color("fff4dc"))
	ui_theme.set_color("font_disabled_color", "Button", Color("d2c6b5"))
	ui_theme.set_constant("separation", "HBoxContainer", 8)
	ui_theme.set_constant("separation", "VBoxContainer", 7)
	ui_theme.set_stylebox("background", "ProgressBar", _box(Color("2f3b42"), Color("493b36"), 2, 0))
	ui_theme.set_stylebox("fill", "ProgressBar", _box(Color("83dbe3"), Color("cbf6f4"), 2, 0))
	theme = ui_theme
	$Top.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	$Top/Row/TitlePlate.add_theme_stylebox_override("panel", _snow_box(Color("774329"), Color("c78d5d"), 12, 12))
	$Top/Row/LivesPlate.add_theme_stylebox_override("panel", _box(Color("51342b"), Color("bb875e"), 12, 11))
	$Top/Row/CoinsPlate.add_theme_stylebox_override("panel", _box(Color("51342b"), Color("bb875e"), 12, 11))
	$Top/Row/WavePlate.add_theme_stylebox_override("panel", _snow_box(Color("175263"), Color("5ca8b4"), 6, 9))
	_set_button_styles(pause_button, Color("744b34"), Color("a56b3e"), Color("543b2e"), Color("5b5149"))
	$Bottom.add_theme_stylebox_override("panel", _snow_box(Color("713e28"), Color("c18852"), 8, 7))
	_set_button_styles(next_wave, Color("3d712f"), Color("58a849"), Color("315c2d"), Color("54594c"))
	_set_button_styles(bell_button, Color("225763"), Color("327b86"), Color("20434e"), Color("4b5457"))
	_set_button_styles(upgrade_button, Color("466f37"), Color("62a450"), Color("355a2e"), Color("55564e"))
	_set_button_styles($Bottom/Row/Restart, Color("634331"), Color("865b3d"), Color("473328"), Color("514942"))
	build_panel.add_theme_stylebox_override("panel", _snow_box(Color("744025"), Color("c68b52"), 11, 14))
	for button in build_buttons.get_children():
		_set_button_styles(button as Button, Color("264c5d"), Color("357488"), Color("1d3e4f"), Color("4c5659"))
	$BuildPanel/Column/Heading/Close.add_theme_stylebox_override("normal", _box(Color("743e34"), Color("d7a278"), 10, 7))
	toast.add_theme_stylebox_override("panel", _snow_box(Color("69452e"), Color("c18b5a"), 9, 9))
	$Overlay/Card.add_theme_stylebox_override("panel", _snow_box(Color("69402a"), Color("d1a16b"), 14, 24))
	$Overlay/Card/Column/Title.add_theme_color_override("font_color", Color("ffe1a8"))


func _set_button_styles(button: Button, normal: Color, hover: Color, pressed: Color, disabled: Color) -> void:
	button.add_theme_stylebox_override("normal", _box(normal, Color("d6a46b"), 9, 7))
	button.add_theme_stylebox_override("hover", _box(hover, Color("ffe3a0"), 9, 7))
	button.add_theme_stylebox_override("pressed", _box(pressed, Color("f7cb80"), 9, 7))
	button.add_theme_stylebox_override("disabled", _box(disabled, Color("857363"), 9, 7))


func _snow_box(fill: Color, border: Color, radius: int, margin: int) -> StyleBoxFlat:
	var box: StyleBoxFlat = _box(fill, border, radius, margin)
	box.border_width_top = 4
	box.border_color = Color("d6e8e9")
	return box


func _box(fill: Color, border: Color, radius: int, margin: int) -> StyleBoxFlat:
	var box: StyleBoxFlat = StyleBoxFlat.new()
	box.bg_color = fill
	box.border_color = border
	box.set_border_width_all(2)
	box.set_corner_radius_all(radius)
	box.content_margin_left = margin
	box.content_margin_right = margin
	box.content_margin_top = margin
	box.content_margin_bottom = margin
	box.shadow_color = Color("231d1b99")
	box.shadow_size = 3
	return box
