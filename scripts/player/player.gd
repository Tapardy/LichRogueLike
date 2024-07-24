extends CharacterBody2D

const SPEED = 200.0
const RUN_MULTIPLIER = 1.75
const JUMP_VELOCITY = -400.0
const COYOTE_TIME = 0.1  # Time in seconds to allow jumps after leaving the ground
const FALL_GRAVITY := 980
const KNOCKBACK_DECAY = 0.8  # Knockback decay rate
const KNOCKBACK_MULTIPLIER_STANDING = 1.0  # Knockback multiplier when standing still
const KNOCKBACK_MULTIPLIER_MOVING = 0.5    # Knockback multiplier when moving (adjusted to be less severe)
const KNOCKBACK_STOP_DURATION = 0.1  # Duration to stop movement during knockback

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var knockback_timer: Timer = $PlayerAttack/KnocbackTimer  # Timer for stopping movement during knockback

var can_move: bool = true
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_jump: bool = true
var knockback_velocity: Vector2 = Vector2.ZERO
var direction: float = 0.0
var original_speed: float = SPEED

func _ready() -> void:
	coyote_timer.wait_time = COYOTE_TIME 
	$Camera2D/CanvasLayer/Sprite2D.visible = false
	$RealmShift.set_tile_maps($"../TileMapLight", $"../TileMapDark")
	
	# Initialize knockback timer
	knockback_timer.wait_time = KNOCKBACK_STOP_DURATION
	knockback_timer.one_shot = true

func _physics_process(delta: float) -> void:
	# Debug
	$HealthComponent/Label2.text = str("VV: ", velocity.y)
	
	if not is_on_floor():
		velocity.y += get_gravity(velocity) * delta
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 3
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or !coyote_timer.is_stopped()):
		if can_jump:
			velocity.y = JUMP_VELOCITY
			can_jump = false 
	
	direction = Input.get_axis("move_left", "move_right")  # Update direction
	if direction > 0:
		sprite_2d.flip_h = false
	elif direction < 0:
		sprite_2d.flip_h = true
	
	if knockback_timer.is_stopped():
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	# Apply knockback velocity
	velocity += knockback_velocity

	# Decay knockback velocity
	knockback_velocity = knockback_velocity * KNOCKBACK_DECAY
	
	# Ensure knockback doesn't affect vertical velocity if on the ground
	if is_on_floor():
		knockback_velocity.y = 0

	# Move the character
	var was_on_floor: bool = is_on_floor()
	move_and_slide()
	
	if was_on_floor and not is_on_floor():
		coyote_timer.start()
	elif not is_on_floor():
		can_jump = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("realm_shift"):
		$RealmShift.handle_realm_shift()

func change_realm(value: int) -> void:
	$RealmShift.change_realm(value)

func _on_coyote_timer_timeout() -> void:
	can_jump = false
	
func get_direction() -> int:
	if sprite_2d.flip_h == true:
		return -1
	else:
		return 1

func get_gravity(velocity: Vector2) -> float:
	if velocity.y < 0:
		return gravity
	return FALL_GRAVITY

func knockback(force: float, x_pos: float, up_force: float):
	var multiplier := KNOCKBACK_MULTIPLIER_STANDING
	if direction != 0:
		multiplier = KNOCKBACK_MULTIPLIER_MOVING
	
	var knockback_direction: float = get_direction()  # 1 for right, -1 for left
	knockback_velocity = Vector2(force * multiplier * -knockback_direction, -force * up_force)
	
	# Stop movement temporarily
	velocity.x = 0
	knockback_timer.start()
	
func _on_knockback_timer_timeout() -> void:
	# Restore normal movement speed after knockback duration
	velocity.x = direction * (SPEED * (RUN_MULTIPLIER if direction != 0 else 1.0))
