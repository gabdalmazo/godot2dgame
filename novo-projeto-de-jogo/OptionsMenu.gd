class_name OptionsMenu
extends Control

## Menu de Opções de Áudio
## Controla o volume dos buses Master, BGM e SFX em tempo real através de sliders lineares convertidos em decibéis.

signal voltar_pressionado

@export_group("Sliders de Áudio")
@export var slider_master: HSlider
@export var slider_bgm: HSlider
@export var slider_sfx: HSlider

@export_group("Navegação")
@export var back_button: Button

func _ready() -> void:
	# Resolução defensiva de nós caso não estejam vinculados no Inspector
	if slider_master == null:
		slider_master = get_node_or_null("%SliderMaster") as HSlider
	if slider_master == null:
		slider_master = find_child("SliderMaster", true, false) as HSlider

	if slider_bgm == null:
		slider_bgm = get_node_or_null("%SliderBGM") as HSlider
	if slider_bgm == null:
		slider_bgm = find_child("SliderBGM", true, false) as HSlider

	if slider_sfx == null:
		slider_sfx = get_node_or_null("%SliderSFX") as HSlider
	if slider_sfx == null:
		slider_sfx = find_child("SliderSFX", true, false) as HSlider

	if back_button == null:
		back_button = get_node_or_null("%BackButton") as Button
	if back_button == null:
		back_button = find_child("BackButton", true, false) as Button

	# Configura parâmetros dos sliders e sincroniza com o volume atual do AudioServer
	_configurar_slider(slider_master, "Master", _on_master_slider_changed)
	_configurar_slider(slider_bgm, "BGM", _on_bgm_slider_changed)
	_configurar_slider(slider_sfx, "SFX", _on_sfx_slider_changed)

	if back_button != null:
		back_button.pressed.connect(_on_back_pressed)

## Configura limites, step e valor inicial do HSlider com base no AudioServer
func _configurar_slider(slider: HSlider, nome_bus: String, callback: Callable) -> void:
	if slider == null:
		push_warning("[OptionsMenu] Slider para o bus '%s' não encontrado!" % nome_bus)
		return
	
	slider.min_value = 0.0
	slider.max_value = 1.0
	slider.step = 0.05
	
	var bus_idx: int = AudioServer.get_bus_index(nome_bus)
	if bus_idx != -1:
		if AudioServer.is_bus_mute(bus_idx):
			slider.value = 0.0
		else:
			var db: float = AudioServer.get_bus_volume_db(bus_idx)
			slider.value = db_to_linear(db)
	else:
		slider.value = 1.0
		push_warning("[OptionsMenu] Bus '%s' não encontrado no AudioServer." % nome_bus)
	
	slider.value_changed.connect(callback)

func _on_master_slider_changed(value: float) -> void:
	_atualizar_volume_bus("Master", value)

func _on_bgm_slider_changed(value: float) -> void:
	_atualizar_volume_bus("BGM", value)

func _on_sfx_slider_changed(value: float) -> void:
	_atualizar_volume_bus("SFX", value)

## Converte valor linear (0.0 a 1.0) para decibéis usando linear_to_db e aplica ao bus
func _atualizar_volume_bus(nome_bus: String, valor_linear: float) -> void:
	var bus_idx: int = AudioServer.get_bus_index(nome_bus)
	if bus_idx == -1:
		push_warning("[OptionsMenu] Bus '%s' não existe no AudioServer!" % nome_bus)
		return
	
	if valor_linear <= 0.001:
		# Muta o bus para silêncio completo quando no zero
		AudioServer.set_bus_mute(bus_idx, true)
		AudioServer.set_bus_volume_db(bus_idx, -80.0)
	else:
		AudioServer.set_bus_mute(bus_idx, false)
		var volume_db: float = linear_to_db(valor_linear)
		AudioServer.set_bus_volume_db(bus_idx, volume_db)

func _on_back_pressed() -> void:
	voltar_pressionado.emit()
	
	# Se este menu estiver embutido como painel em outra cena, apenas esconde
	if get_parent() is Control and get_parent() != get_tree().root:
		hide()
	else:
		# Se carregado como cena autônoma, retorna ao Menu Principal
		get_tree().change_scene_to_file("res://MainMenu.tscn")
