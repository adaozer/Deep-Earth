extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	$VBoxContainer/Resume.pressed.connect(_on_resume_pressed)
	$VBoxContainer/Quit.pressed.connect(_on_quit_pressed)
	$VBoxContainer/Settings.pressed.connect(_on_settings_pressed)

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		var current_scene = get_tree().current_scene.scene_file_path
		if current_scene != "res://scenes/main_menu.tscn":
			MusicManager.get_node("click").play()
			toggle_pause()
		
func toggle_pause():
	visible = !visible
	get_tree().paused = visible
	
func _on_resume_pressed():
	MusicManager.get_node("click").play()
	toggle_pause()

func _on_settings_pressed():
	MusicManager.get_node("click").play()
	SettingsMenu.get_node("settings_menu").open("pause_menu")
	
func _on_quit_pressed():
	MusicManager.get_node("click").play()
	MusicManager.get_node("AudioStreamPlayer").stop()
	get_tree().paused = false
	visible = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
