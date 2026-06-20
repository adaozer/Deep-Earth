extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicManager.get_node("AudioStreamPlayer").stop()
	$AudioStreamPlayer.play()
	$VBoxContainer/BackButton.pressed.connect(_on_back_pressed)
	
func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
