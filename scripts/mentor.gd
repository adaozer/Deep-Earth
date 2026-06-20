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
			"Press E to read the dialogue",
			"Welcome traveller to our kingdom, the Underworld!",
			"Many have come before you, and many have failed",
			"I hope you will be the one who succeeds",
			"See those vines? If you're strong enough, you should be able to grab onto them with %s and swing across" % grab_key,
			"And I'm sure you already know how to phase below surfaces with %s" % phase_key,
			"Good luck! We are counting on you!",
		])
	elif dialogue_set == 1:
		DialogueManager.start_dialogue([
			"This is where it all began",
			"First it started with the plants",
			"Then the living creatures",
			"Now its spread to the structure of the Underworld itself",
			"Now its consumed almost everything",
			"And you can see it trying to reach the dirt above"
		])
	else:
		DialogueManager.start_dialogue([
			"I see you met a follower",
			"They are agents of the corruption",
			"You are getting close" 
		])
