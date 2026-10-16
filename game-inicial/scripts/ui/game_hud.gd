class_name AuroraHUD
extends Control

signal next_wave_requested
signal pause_requested
signal restart_requested
signal build_requested(index: int)
signal close_requested

@onready var stats: Label = $Top/Row/Stats
@onready var state_label: Label = $Bottom/Row/State
@onready var message: Label = $Message
@onready var next_wave: Button = $Bottom/Row/NextWave
@onready var pause_button: Button = $Top/Row/Pause
@onready var build_panel: PanelContainer = $BuildPanel
@onready var build_title: Label = $BuildPanel/Column/Heading/Title
@onready var build_buttons: HBoxContainer = $BuildPanel/Column/Choices
@onready var overlay: ColorRect = $Overlay
@onready var overlay_title: Label = $Overlay/Card/Column/Title
@onready var overlay_body: Label = $Overlay/Card/Column/Body
@onready var resume: Button = $Overlay/Card/Column/Resume


func _ready() -> void:
	_install_theme()
	next_wave.pressed.connect(func() -> void: next_wave_requested.emit())
	pause_button.pressed.connect(func() -> void: pause_requested.emit())
	$Bottom/Row/Restart.pressed.connect(func() -> void: restart_requested.emit())
	resume.pressed.connect(func() -> void: pause_requested.emit())
	$Overlay/Card/Column/Restart.pressed.connect(func() -> void: restart_requested.emit())
	$BuildPanel/Column/Heading/Close.pressed.connect(func() -> void: close_requested.emit())
	for index in build_buttons.get_child_count():
		var button: Button = build_buttons.get_child(index) as Button
		button.pressed.connect(_request_build.bind(index))
	build_panel.hide()
	overlay.hide()


func _request_build(index: int) -> void:
	build_requested.emit(index)


func update_status(coins: int, lives: int, wave: int, total: int, alive: int, state: String, can_start: bool) -> void:
	stats.text = "♥ %d vidas     •     %d moedas     •     Onda %d / %d" % [lives, coins, wave, total]
	state_label.text = "%s  •  %d na trilha" % [state, alive]
	next_wave.disabled = not can_start
	next_wave.text = "Iniciar onda %d" % mini(wave + 1, total)
	pause_button.disabled = state in ["Vitória", "Derrota"]
	pause_button.text = "Retomar" if state == "Pausado" else "Pausar · Esc"
	overlay.visible = state in ["Pausado", "Vitória", "Derrota"]
	resume.visible = state == "Pausado"
	overlay_title.text = state
	match state:
		"Pausado":
			overlay_body.text = "A defesa está em pausa.\nRetome para continuar de onde parou."
		"Vitória":
			overlay_body.text = "O sino continua brilhando!\nAs cinco ondas terminaram.\nVidas restantes: %d" % lives
		"Derrota":
			overlay_body.text = "O inverno alcançou o sino.\nExperimente combinar flechas, gelo e magia."


func set_message(value: String) -> void:
	message.text = value


func show_build_menu(pad_id: int, catalog: Array[TDTowerData], coins: int, allowed: bool) -> void:
	build_panel.show()
	$PrototypeNote.hide()
	build_title.text = "Base %d — escolha uma torre" % pad_id
	for index in build_buttons.get_child_count():
		var button: Button = build_buttons.get_child(index) as Button
		button.show()
		if index >= catalog.size():
			button.disabled = true
			continue
		var data: TDTowerData = catalog[index]
		button.text = "%s · %d moedas" % [data.display_name, data.cost]
		button.tooltip_text = "%s\nDano: %.0f | Alcance: %.0f | Intervalo: %.2fs" % [data.description, data.damage, data.attack_range, data.attack_interval]
		button.disabled = not allowed or coins < data.cost
		button.modulate = data.tint.lightened(0.35)


func show_tower_info(pad_id: int, data: TDTowerData) -> void:
	build_panel.show()
	$PrototypeNote.hide()
	build_title.text = "Base %d — %s\n%s · Dano %.0f · Alcance %.0f · Disparo %.2fs" % [pad_id, data.display_name, data.description, data.damage, data.attack_range, data.attack_interval]
	for button in build_buttons.get_children():
		button.hide()


func close_build_menu() -> void:
	build_panel.hide()
	$PrototypeNote.show()


func _install_theme() -> void:
	var ui_theme: Theme = Theme.new()
	ui_theme.default_font_size = 18
	var panel: StyleBoxFlat = _box(Color("142c3bef"), Color("507986"))
	ui_theme.set_stylebox("panel", "PanelContainer", panel)
	ui_theme.set_stylebox("normal", "Button", _box(Color("284b5b"), Color("648c96")))
	ui_theme.set_stylebox("hover", "Button", _box(Color("376779"), Color("b4f2ed")))
	ui_theme.set_stylebox("pressed", "Button", _box(Color("163b4b"), Color("e9d392")))
	ui_theme.set_stylebox("disabled", "Button", _box(Color("24343d"), Color("43535c")))
	var focus: StyleBoxFlat = _box(Color(0, 0, 0, 0), Color("f0d790"))
	focus.draw_center = false
	ui_theme.set_stylebox("focus", "Button", focus)
	ui_theme.set_color("font_color", "Label", Color("eef8f5"))
	ui_theme.set_color("font_color", "Button", Color("eef8f5"))
	ui_theme.set_color("font_disabled_color", "Button", Color("91a0a7"))
	ui_theme.set_constant("separation", "HBoxContainer", 12)
	ui_theme.set_constant("separation", "VBoxContainer", 10)
	theme = ui_theme


func _box(fill: Color, border: Color) -> StyleBoxFlat:
	var box: StyleBoxFlat = StyleBoxFlat.new()
	box.bg_color = fill
	box.border_color = border
	box.set_border_width_all(1)
	box.set_corner_radius_all(8)
	box.content_margin_left = 14
	box.content_margin_right = 14
	box.content_margin_top = 10
	box.content_margin_bottom = 10
	return box
