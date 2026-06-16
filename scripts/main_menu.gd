extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/NewGame.pressed.connect(_on_new_game_pressed)
	$VBoxContainer/LoadGame.pressed.connect(_on_load_game_pressed)
	$VBoxContainer/Settings.pressed.connect(_on_settings_pressed)
	$VBoxContainer/Quit.pressed.connect(_on_quit_pressed)

func _on_new_game_pressed():
	MusicManager.get_node("click").play()
	SaveManager.reset_progress()
	var music = MusicManager.get_node("AudioStreamPlayer")
	if not music.playing:
		music.play()
	get_tree().change_scene_to_file("res://scenes/level1.tscn")
	
func _on_load_game_pressed():
	MusicManager.get_node("click").play()
	var last_level = SaveManager.get_last_level()
	if last_level == "res://scenes/level1.tscn" and not SaveManager.has_save():
		get_tree().change_scene_to_file("res://scenes/level1.tscn")
	else:
		var music = MusicManager.get_node("AudioStreamPlayer")
		if not music.playing:
			music.play()
		get_tree().change_scene_to_file(last_level)
		
func _on_settings_pressed():
	MusicManager.get_node("click").play()
	SettingsMenu.get_node("settings_menu").open("main_menu")
	
func _on_quit_pressed():
	get_tree().quit()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
