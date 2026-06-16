extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	$VBoxContainer/bg_slider.min_value = -40.0
	$VBoxContainer/bg_slider.max_value = 40.0
	$VBoxContainer/bg_slider.value = 0.0
	$VBoxContainer/sfx_slider.min_value = -40.0
	$VBoxContainer/sfx_slider.max_value = 40.0
	$VBoxContainer/sfx_slider.value = 0.0

	$VBoxContainer/bg_slider.value_changed.connect(_on_bg_volume_changed)
	$VBoxContainer/sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	$VBoxContainer/Controls.pressed.connect(_on_controls_pressed)
	$VBoxContainer/Back.pressed.connect(_on_back_pressed)
	$VBoxContainer2/Back.pressed.connect(_on_controls_back_pressed)
	
	$VBoxContainer2.visible = false
	_build_controls_panel()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _build_controls_panel():
	var placeholder = $VBoxContainer2/HBoxContainer
	placeholder.queue_free()
	
func _on_bg_volume_changed(value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)

func _on_sfx_volume_changed(value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)

func _on_back_pressed():
	MusicManager.get_node("click").play()
	visible = false
	if PauseMenu.get_node("pause_menu").visible:
		PauseMenu.get_node("pause_menu/VBoxContainer").visible = true
	else:
		get_tree().get_root().get_node("main_menu").visible = true

func _on_controls_pressed():
	MusicManager.get_node("click").play()
	$VBoxContainer.visible = false
	$VBoxContainer2.visible = true

func _on_controls_back_pressed():
	MusicManager.get_node("click").play()
	$VBoxContainer2.visible = false
	$VBoxContainer.visible = true

func open(from: String):
	visible = true
	$VBoxContainer.visible = true
	$VBoxContainer2.visible = false
	$backdrop.visible = (from == "main_menu")
	if from == "main_menu":
		get_tree().get_root().get_node("main_menu").visible = false
	elif from == "pause_menu":
		PauseMenu.get_node("pause_menu/VBoxContainer").visible = false
func _process(delta: float) -> void:
	pass
