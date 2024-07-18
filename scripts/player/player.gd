extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var coyote_timer: Timer = $CoyoteTimer
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# Handle jump.
		
	if Input.is_action_just_pressed("jump") and (is_on_floor() or !coyote_timer.is_stopped()):
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("move_left", "move_right")
	if direction > 0:
		sprite_2d.flip_h = true
	elif direction < 0:
		sprite_2d.flip_h = false
		
	if direction:
		if Input.is_action_pressed("run"):
			velocity.x = direction * (SPEED * 1.75)
		else:
			velocity.x = direction * SPEED
	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	var was_on_floor = is_on_floor()
		
	move_and_slide()
	
	if was_on_floor && !is_on_floor():
		coyote_timer.start()

