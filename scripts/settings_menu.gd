extends Control

var listening_for_action = ""
var action_buttons = {}
const ACTIONS = ["left", "right", "jump", "phase", "grab"]
var my_font = load("res://assets/font/Dekartaretro.ttf")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	$VBoxContainer/bg_slider.min_value = 0.0
	$VBoxContainer/bg_slider.max_value = 1.0
	$VBoxContainer/bg_slider.value = 0.5
	$VBoxContainer/sfx_slider.min_value = 0.0
	$VBoxContainer/sfx_slider.max_value = 1.0
	$VBoxContainer/sfx_slider.value = 0.5

	$VBoxContainer/bg_slider.value_changed.connect(_on_bg_volume_changed)
	$VBoxContainer/sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	$VBoxContainer/Controls.pressed.connect(_on_controls_pressed)
	$VBoxContainer/Back.pressed.connect(_on_back_pressed)
	$VBoxContainer2/Back.pressed.connect(_on_controls_back_pressed)
	$VBoxContainer/RestoreDefaults.pressed.connect(_on_restore_defaults_pressed)
	$VBoxContainer2/RestoreDefaultsControls.pressed.connect(_on_restore_defaults_controls_pressed)
	
	$VBoxContainer2.visible = false
	_build_controls_panel()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _build_controls_panel():
	var placeholder = $VBoxContainer2/HBoxContainer
	placeholder.queue_free()
	
	for action in ACTIONS:
		var hbox = HBoxContainer.new()
		hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		var label = Label.new()
		label.text = action.capitalize()
		label.custom_minimum_size.x = 250
		label.add_theme_font_override("font", my_font)
		label.add_theme_font_size_override("font_size", 32)
		
		var button = Button.new()
		button.text = _get_action_key(action)
		button.custom_minimum_size.x = 250
		button.add_theme_font_override("font", my_font)
		button.add_theme_font_size_override("font_size", 32)
		button.pressed.connect(_on_rebind_pressed.bind(action, button))
		action_buttons[action] = button
		
		var style = StyleBoxFlat.new()
		style.bg_color = Color("5a4b0370")
		style.corner_radius_bottom_left = 4
		style.corner_radius_top_left = 4
		style.corner_radius_top_right = 4
		style.corner_radius_bottom_right = 4
		
		style.content_margin_bottom = 12
		style.content_margin_top = 12
		style.content_margin_right = 24
		style.content_margin_left = 24
		button.add_theme_stylebox_override("normal", style)
		
		var hover = StyleBoxFlat.new()
		hover.bg_color = Color("88730770")
		hover.corner_radius_bottom_left = 4
		hover.corner_radius_top_left = 4
		hover.corner_radius_top_right = 4
		hover.corner_radius_bottom_right = 4
		hover.content_margin_bottom = 12
		hover.content_margin_top = 12
		hover.content_margin_right = 24
		hover.content_margin_left = 24
		button.add_theme_stylebox_override("hover", hover)
		
		hbox.add_child(label)
		hbox.add_child(button)
		$VBoxContainer2.add_child(hbox)
		$VBoxContainer2.move_child(hbox, $VBoxContainer2.get_child_count() - 3)
	
func _get_action_key(action: String) -> String:
	var events = InputMap.action_get_events(action)
	for event in events:
		if event is InputEventKey:
			return event.as_text().replace(" - Physical", "")
	return "Unbound"

func _input(event):
	if listening_for_action == "":
		return
	if (event is InputEventKey and event.pressed) or (event is InputEventMouseButton and event.pressed):
		for action in ACTIONS:
			if action == listening_for_action:
				continue
			var events = InputMap.action_get_events(action)
			for existing in events:
				if existing is InputEventKey and event is InputEventKey:
					if existing.keycode == event.keycode:
						InputMap.action_erase_events(action)
						action_buttons[action].text = "Unbound"
				elif existing is InputEventMouseButton and event is InputEventMouseButton:
					if existing.button_index == event.button_index:
						InputMap.action_erase_events(action)
						action_buttons[action].text = "Unbound"
		InputMap.action_erase_events(listening_for_action)
		InputMap.action_add_event(listening_for_action, event)
		action_buttons[listening_for_action].text = event.as_text().replace(" - Physical", "")
		listening_for_action = ""
		get_viewport().set_input_as_handled()
		SaveManager.save_settings(
			$VBoxContainer/bg_slider.value,
			$VBoxContainer/sfx_slider.value,
			action_buttons
		)

func _on_rebind_pressed(action: String, button: Button):
	listening_for_action = action
	button.text = "Press any key"

func _on_bg_volume_changed(value: float):
	var db = linear_to_db(value) if value > 0 else -80.0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), db)
	SaveManager.save_settings(value, 
	$VBoxContainer/sfx_slider.value,
	action_buttons
	)

func _on_restore_defaults_pressed():
	var db = linear_to_db(0.5)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), db)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), db)
	$VBoxContainer/bg_slider.value = 0.5
	$VBoxContainer/sfx_slider.value = 0.5
	SaveManager.save_settings(0.5, 0.5, action_buttons)

func _on_restore_defaults_controls_pressed():
	InputMap.load_from_project_settings()
	for action in action_buttons:
		action_buttons[action].text = _get_action_key(action)
	SaveManager.save_settings($VBoxContainer/bg_slider.value, $VBoxContainer/sfx_slider.value, 
	action_buttons)
	
func _on_sfx_volume_changed(value: float):
	var db = linear_to_db(value) if value > 0 else -80.0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), db)
	SaveManager.save_settings($VBoxContainer/bg_slider.value,
	value, 
	action_buttons)

func _on_back_pressed():
	MusicManager.get_node("click").play()
	visible = false
	if PauseMenu.get_node("pause_menu").visible:
		PauseMenu.get_node("pause_menu/VBoxContainer").visible = true
	else:
		get_tree().get_root().get_node("main_menu").visible = true

func _on_controls_pressed():
	MusicManager.get_node("click").play()
	for action in action_buttons:
		action_buttons[action].text = _get_action_key(action)
	$VBoxContainer.visible = false
	$VBoxContainer2.visible = true

func _unhandled_input(event):
	if not visible:
		return
	if event.is_action_pressed("pause"):
		if $VBoxContainer2.visible:
			_on_controls_back_pressed()
		else:
			_on_back_pressed()
		get_viewport().set_input_as_handled()
	

func _on_controls_back_pressed():
	MusicManager.get_node("click").play()
	$VBoxContainer2.visible = false
	$VBoxContainer.visible = true

func open(from: String):
	visible = true
	$VBoxContainer.visible = true
	$VBoxContainer2.visible = false
	$backdrop.visible = (from == "main_menu")
	
	if SaveManager.has_settings():
		$VBoxContainer/bg_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
		$VBoxContainer/sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	else:
		$VBoxContainer/bg_slider.value = 0.5
		$VBoxContainer/sfx_slider.value = 0.5
	
	if from == "main_menu":
		get_tree().get_root().get_node("main_menu").visible = false
	elif from == "pause_menu":
		PauseMenu.get_node("pause_menu/VBoxContainer").visible = false

func _process(delta: float) -> void:
	pass
