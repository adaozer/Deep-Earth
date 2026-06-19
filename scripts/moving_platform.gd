extends AnimatableBody2D

@export var move_distance: float = 100.0
@export var move_speed: float = 1.0
@export var horizontal: bool = true

var start_position: Vector2
var elapsed: float = 0.0

func _ready():
	call_deferred("_init_position")
	$platform_move.play()

func _init_position():
	start_position = global_position

func _physics_process(delta: float) -> void:
	elapsed += delta
	var offset = sin(elapsed * move_speed) * move_distance
	if horizontal:
		global_position = start_position + Vector2(offset, 0)
	else:
		global_position = start_position + Vector2(0, offset)
