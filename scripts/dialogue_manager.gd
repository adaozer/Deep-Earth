extends CanvasLayer

var lines: Array = []
var current_line = 0
var is_active = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Control.visible = false

func start_dialogue(dialogue_lines: Array):
	lines = dialogue_lines
	current_line = 0
	is_active = true
	$Control.visible = true
	_show_line()
	
func _show_line():
	$Control/Panel/dialogue_text.text = lines[current_line]

func _unhandled_input(event: InputEvent) -> void:
	if not is_active:
		return
	if event.is_action_pressed("interact"):
		current_line += 1
		if current_line >= lines.size():
			_end_dialogue()
		else:
			_show_line()
		get_viewport().set_input_as_handled()
		
func _end_dialogue():
	is_active = false
	$Control.visible = false

func force_close():
	is_active = false
	$Control.visible = false
