extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/Play.pressed.connect(_on_play_pressed)
	$VBoxContainer/Settings.pressed.connect(_on_settings_pressed)
	$VBoxContainer/Quit.pressed.connect(_on_quit_pressed)

func _on_play_pressed():
	MusicManager.get_node("click").play()
	var music = MusicManager.get_node("AudioStreamPlayer")
	if not music.playing:
		music.play()
	var last_level = SaveManager.get_last_level()
	get_tree().change_scene_to_file(last_level)
	
func _on_settings_pressed():
	MusicManager.get_node("click").play()
	SettingsMenu.get_node("settings_menu").open("main_menu")
	
func _on_quit_pressed():
	get_tree().quit()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
