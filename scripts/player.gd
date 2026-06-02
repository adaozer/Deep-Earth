extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_dead = false
const SPEED = 300.0
const JUMP_VELOCITY = -850.0
var current_phase_spot = null
var phase_timer = 0.0
const PHASE_HOLD_TIME = 0.8
var swinging = false
var swing_anchor: Vector2
var swing_length: float
var swing_angle: float
var swing_angular_velocity: float = 0.0
const SWING_SPEED = 5.0
const SWING_CONTROL = 4.0
const SWING_DAMPING = 0.999
var available_vine = null

func _physics_process(delta: float) -> void:
	if swinging:
		_process_swing(delta)
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite_2d.animation = "jump"
	elif velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation = "walk"
	else:
		animated_sprite_2d.animation = "idle"

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is TileMapLayer:
			var pos = collision.get_position() - collision.get_normal() * 2
			var tile_pos = collider.local_to_map(collider.to_local(pos))
			var tile_data = collider.get_cell_tile_data(tile_pos)
			if tile_data and tile_data.get_custom_data("is_spike"):
				die()
				
	if available_vine and Input.is_action_just_pressed("grab") and not swinging:
		try_grab_vine(available_vine)
		
	if current_phase_spot and Input.is_action_pressed("phase"):
		phase_timer += delta
		if phase_timer >= PHASE_HOLD_TIME:
			global_position = current_phase_spot.exit_position
			phase_timer = 0.0
	else:
		phase_timer = 0.0
		
	if direction == 1.0:
		animated_sprite_2d.flip_h = false
	elif direction == -1.0:
		animated_sprite_2d.flip_h = true

func enter_phase_spot(spot):
	current_phase_spot = spot
	
func exit_phase_spot():
	current_phase_spot = null
	phase_timer = 0.0
	
func try_grab_vine(anchor):
	swinging = true
	swing_anchor = anchor.global_position
	swing_length = global_position.distance_to(swing_anchor)
	var offset = global_position - swing_anchor
	swing_angle = atan2(offset.x, offset.y)
	swing_angular_velocity = 0.0
		
func _process_swing(delta: float) -> void:
	var direction = Input.get_axis("left", "right")
	swing_angular_velocity -= (SWING_SPEED * sin(swing_angle)) * delta
	swing_angular_velocity += direction * SWING_CONTROL * delta
	swing_angular_velocity *= pow(SWING_DAMPING, delta * 60)
	
	swing_angle += swing_angular_velocity * delta
	global_position = swing_anchor + Vector2(
		sin(swing_angle) * swing_length,
		cos(swing_angle) * swing_length
	)
	if Input.is_action_just_pressed("jump"):
		swinging = false
		var speed = swing_angular_velocity * swing_length
		velocity = Vector2(
			cos(swing_angle) * speed,
			-sin(swing_angle) * speed
		)
func die():
	if is_dead:
		return
	is_dead = true
	get_tree().reload_current_scene()
