extends Area2D
@export var exit_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.enter_phase_spot(self)

func _on_body_exited(body):
	if body.is_in_group("player"):
		body.exit_phase_spot()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
