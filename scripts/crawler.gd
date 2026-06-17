extends CharacterBody2D

@export var speed: float = 80.0
var direction: float = 1.0
var bt: BTNode

func _ready():
	$hitbox.body_entered.connect(_on_hitbox_body_entered)
	$move.play()
	bt = build_tree()

func build_tree() -> BTNode:
	return BTFallback.new([
		BTSequence.new([
			BTCondition.new(func(actor): return actor.is_on_wall()),
			BTAction.new(func(actor): actor.turn_around(); return BTNode.Status.SUCCESS)
		]),
		BTSequence.new([
			BTCondition.new(func(actor): return actor.edge_ahead()),
			BTAction.new(func(actor): actor.turn_around(); return BTNode.Status.SUCCESS)
		]),
		BTAction.new(func(actor): actor.patrol(); return BTNode.Status.RUNNING)
	])
func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta
	move_and_slide()
	bt.tick(self)
	
func edge_ahead() -> bool:
	if not is_on_floor():
		return false
	var space = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		global_position + Vector2(direction * 27, 0),
		global_position + Vector2(direction * 27, 40)
	)
	query.exclude = [self]
	var result = space.intersect_ray(query)
	return result.is_empty()

func patrol():
	velocity.x = direction * speed
	
func turn_around():
	direction *= -1
	$AnimatedSprite2D.flip_h = direction < 0

func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		body.die("slime")
