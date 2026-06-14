extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/Play.pressed.connect(_on_play_pressed)
	$VBoxContainer/Quit.pressed.connect(_on_quit_pressed)

func _on_play_pressed():
	$click.play()
	await $click.finished
	get_tree().change_scene_to_file("res://scenes/level1.tscn")
	
func _on_quit_pressed():
	$click.play()
	await $click.finished
	get_tree().quit()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
