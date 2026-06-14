extends AnimatableBody2D

@export var move_distance: float = 100.0
@export var move_speed: float = 1.0
@export var horizontal: bool = true

var start_position: Vector2

func _ready():
	call_deferred("_init_position")
	$platform_move.play()

func _init_position():
	start_position = global_position

func _physics_process(delta: float) -> void:
	var offset = sin(Time.get_ticks_msec() / 1000.0 * move_speed) * move_distance
	if horizontal:
		global_position = start_position + Vector2(offset, 0)
	else:
		global_position = start_position + Vector2(0, offset)
