extends CharacterBody2D

@export var speed: float = 80.0
var direction: float = 1.0

func _ready():
	$hitbox.body_entered.connect(_on_hitbox_body_entered)
	$move.play()

func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta
	velocity.x = direction * speed
	move_and_slide()
	
	if is_on_wall():
		turn_around()
	
	# check for edge ahead
	var space = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		global_position + Vector2(direction * 0, 0),
		global_position + Vector2(direction * 0, 40)
	)
	query.exclude = [self]
	var result = space.intersect_ray(query)
	if not result and is_on_floor():
		turn_around()

func turn_around():
	direction *= -1
	$AnimatedSprite2D.flip_h = direction < 0

func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		body.die("slime")
