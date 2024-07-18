extends State
class_name PlayerJump

@export var player: CharacterBody2D

const JUMP_VELOCITY = -400.0
@onready var sprite_2d = $"../../Sprite2D"

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func enter():
	print("PlayerJump state entered")
	if not player:
		print("Player reference is null")
	else:
		player.velocity.y = JUMP_VELOCITY
		player.get_node("AnimationPlayer").play("jump")

func exit():
	# Optionally handle any cleanup when exiting the jump state
	pass

func update(delta: float):
	if player.is_on_floor():
		Transitioned.emit(self, "idle")  # Transition to idle state when landing

	if Input.is_action_just_pressed("melee_attack"):
		Transitioned.emit(self, "attacking")  # Transition to attacking state if melee attack is pressed during jump

func physics_update(delta: float):
	if not player.is_on_floor():
		player.velocity.y += gravity * delta

	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		if direction > 0:
			sprite_2d.flip_h = true
		else:
			sprite_2d.flip_h = false

		player.velocity.x = direction * $"../Moving".SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, $"../Moving".SPEED)

	player.move_and_slide()
