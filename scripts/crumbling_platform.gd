extends StaticBody2D

@onready var collision = $CollisionShape2D
@onready var sprite = $Sprite2D

const CRUMBLE_TIME = 1.0
const RESPAWN_TIME = 5.0

var crumble_timer = 0.0
var respawn_timer = 0.0
var state = "idle"
var shake_tween = null

func _physics_process(delta):
	match state:
		"crumbling":
			crumble_timer += delta
			if crumble_timer >= CRUMBLE_TIME:
				break_platform()
		"broken":
			respawn_timer += delta
			if respawn_timer >= RESPAWN_TIME:
				respawn_platform()

func start_crumbling():
	if state == "idle":
		state = "crumbling"
		crumble_timer = 0.0
		shake_tween = create_tween().set_loops()
		shake_tween.tween_property(sprite, "position:x", 3.0, 0.05)
		shake_tween.tween_property(sprite, "position:x", -3.0, 0.05)

func break_platform():
	state = "broken"
	respawn_timer = 0.0
	if shake_tween:
		shake_tween.kill()
	sprite.visible = false
	collision.disabled = true

func respawn_platform():
	state = "idle"
	sprite.visible = true
	sprite.position.x = 0.0
	collision.disabled = false

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		start_crumbling()

func _on_area_2d_body_exited(body):
	if body.is_in_group("player") and state == "crumbling":
		state = "idle"
		crumble_timer = 0.0
		if shake_tween:
			shake_tween.kill()
		sprite.position.x = 0.0
