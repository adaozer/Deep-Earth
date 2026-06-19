extends Area2D
@export var npc_id: String = "wanderer"
@export var dialogue_set: int = 0
var interacted: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player") and not interacted and not DialogueManager.is_active:
		talk()

func get_key_for(action):
	var events = InputMap.action_get_events(action)
	for event in events:
		if event is InputEventKey:
			return event.as_text().replace(" - Physical", "")
		elif event is InputEventMouseButton:
			return "Mouse " + str(event.button_index)
	return "?"
func talk():
	interacted = true
	var grab_key = get_key_for("grab")
	var phase_key = get_key_for("phase")
	if dialogue_set == 0:
		DialogueManager.start_dialogue([
			"Welcome traveller to our kingdom!",
			"Many have come before you, and many have failed",
			"I hope you will be the one who succeeds",
			"See those vines? If you're strong enough, you should be able to grab onto them with %s and swing across" % grab_key,
			"And I'm sure you already know how to phase below surfaces with %s" % phase_key,
			"Good luck! We are counting on you!" 
		])
	elif dialogue_set == 1:
		DialogueManager.start_dialogue([
			"You again!",
			"So you did make it this far..",
			"I pray that you will overcome the challenges facing you next."
		])
	else:
		DialogueManager.start_dialogue([
			"GJ"
		])
