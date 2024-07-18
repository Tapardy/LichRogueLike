extends State
class_name PlayerMoving

@export var player: CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var sprite_2d = $"../../Sprite2D"
@onready var coyote_timer = $"../../CoyoteTimer"

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func enter()-> void:
	pass

func physics_update(delta: float)-> void:
	if not player.is_on_floor():
		player.velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and (player.is_on_floor() or not coyote_timer.is_stopped()):
		Transitioned.emit(self, "jumping")
		#player.velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("move_left", "move_right")
	if direction > 0:
		sprite_2d.flip_h = true
	elif direction < 0:
		sprite_2d.flip_h = false

	if direction:
		if Input.is_action_pressed("run"):
			player.velocity.x = direction * (SPEED * 1.75)
		else:
			player.velocity.x = direction * SPEED
	else:
		Transitioned.emit(self, "idle")

	var was_on_floor = player.is_on_floor()
	player.move_and_slide()

	if was_on_floor and not player.is_on_floor():
		coyote_timer.start()
