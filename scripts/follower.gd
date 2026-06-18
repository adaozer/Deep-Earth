extends CharacterBody2D

@export var follow_delay: float = 1.25
var bt: BTNode
var position_history: Array = []
var activated: bool = false
var start_position: Vector2
var last_player_pos: Vector2
var pos_initialised: bool = false
var player: Node2D
var total_movement: float = 0.0

func _ready():
	$hitbox.body_entered.connect(_on_hitbox_body_entered)
	bt = build_tree()
	start_position = global_position
	visible = false
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	
func build_tree() -> BTNode:
	return BTFallback.new([
		BTSequence.new([
			BTCondition.new(func(actor): return actor.has_target()),
			BTAction.new(func(actor): actor.chase(); return BTNode.Status.RUNNING)
		]),
		BTAction.new(func(actor): actor.idle(); return BTNode.Status.RUNNING)
	])
	
func _physics_process(delta: float) -> void:
	if player:
		if not pos_initialised:
			last_player_pos = player.global_position
			pos_initialised = true
		total_movement += abs(player.global_position.x - last_player_pos.x)
		if not activated and total_movement > 100:
			activated = true
		last_player_pos = player.global_position
		position_history.append({
			"pos": player.global_position,
			"time": Time.get_ticks_msec() / 1000.0
					})
		var cutoff = Time.get_ticks_msec() / 1000.0 - follow_delay
		while position_history.size() > 0 and position_history[0]["time"] < cutoff:
			position_history.pop_front()
	bt.tick(self)
	
func chase():
	var oldest_time = position_history[0]["time"]
	var newest_time = position_history[-1]["time"]
	if newest_time - oldest_time < follow_delay - 0.1:
		return
	if not visible:
		visible = true
	var target = position_history[0]["pos"]
	var dir = target - global_position
	if abs(dir.x) > 1:
		$AnimatedSprite2D.flip_h = dir.x < 0
	global_position = target
	
func has_target() -> bool:
	return activated and position_history.size() > 0 and player != null
	
func idle():
	velocity = Vector2.ZERO
	
func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		body.die()
	
