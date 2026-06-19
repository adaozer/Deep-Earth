extends Node

const SAVE_PATH = "user://save.cfg"
var config = ConfigFile.new()

func _ready():
	load_save()
	get_tree().root.child_entered_tree.connect(func(node):
		await get_tree().process_frame
		var scene = get_tree().current_scene
		if scene and scene.scene_file_path.contains("level"):
			save_progress(scene.scene_file_path)
	)

func reset_progress():
	config.erase_section_key("progress", "last_level")
	config.erase_section("npcs")
	config.save(SAVE_PATH)

func has_save() -> bool:
	var test = ConfigFile.new()
	return test.load(SAVE_PATH) == OK and test.has_section_key("progress", "last_level")
	
func save_settings(music_vol: float, sfx_vol: float, bindings: Dictionary):
	config.set_value("settings", "music_volume", music_vol)
	config.set_value("settings", "sfx_volume", sfx_vol)
	for action in bindings:
		var event = InputMap.action_get_events(action)
		if event.size() > 0 and event[0] is InputEventKey:
			config.set_value("bindings", action, event[0].physical_keycode)
	config.save(SAVE_PATH)
 	
func save_progress(level_path : String):
	config.set_value("progress", "last_level", level_path)
	config.save(SAVE_PATH)
	
func load_save():
	var default_db = linear_to_db(0.5)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), default_db)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), default_db)
	var err = config.load(SAVE_PATH)
	if err != OK:
		return
		
	var music_vol = config.get_value("settings", "music_volume", 0.5)
	var sfx_vol =  config.get_value("settings", "sfx_volume", 0.5)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_vol) if music_vol > 0 else -80.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_vol) if sfx_vol > 0 else -80.0)
	
	for action in ["left", "right", "jump", "phase", "grab"]:
		if config.has_section_key("bindings", action):
			var keycode = config.get_value("bindings", action)
			if keycode == 0:
				continue
			var event = InputEventKey.new()
			event.physical_keycode = keycode
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, event)
	
func get_last_level() -> String:
	return config.get_value("progress", "last_level", "res://scenes/level1.tscn")

func has_settings() -> bool:
	var test = ConfigFile.new()
	return test.load(SAVE_PATH) == OK and test.has_section("settings")

func has_met_at(npc_id: String) -> bool:
	config.load(SAVE_PATH)
	return config.get_value("npcs", npc_id, false)
	
func set_met_at(npc_id: String):
	config.set_value("npcs", npc_id, true)
	config.save(SAVE_PATH)
