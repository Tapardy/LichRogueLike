extends State
class_name PlayerIdle

@export var player: CharacterBody2D

func enter():
	$"../../AnimationPlayer".play("idle")

func exit():
	# Optionally handle any cleanup when exiting the idle state
	pass

func update(delta: float):
	if Input.is_action_pressed("move_left"):
		player.velocity.x = -$"../Moving".SPEED
	elif Input.is_action_pressed("move_right"):
		player.velocity.x = $"../Moving".SPEED
	else:
		player.velocity.x = 0

	if Input.is_action_just_pressed("melee_attack"):
		Transitioned.emit(self, "attacking")
	elif Input.is_action_just_pressed("jump"):
		Transitioned.emit(self, "jumping")

func physics_update(delta: float):
	if not player.is_on_floor():
		Transitioned.emit(self, "air")
		return
	#player.move_and_slide()
