extends CharacterBody2D

var SPEED: float = 200.0
const RUN_MULTIPLIER = 1.75
const JUMP_VELOCITY = -400.0
const COYOTE_TIME = 0.1
var FALL_GRAVITY: float = 980
const KNOCKBACK_DECAY = 0.8
const KNOCKBACK_MULTIPLIER_STANDING = 1.0
const KNOCKBACK_MULTIPLIER_MOVING = 0.5
const KNOCKBACK_STOP_DURATION = 0.1

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var knockback_timer: Timer = $PlayerAttack/KnockbackTimer
@onready var dash_timer: Timer = $DashTimer

var can_move: bool = true
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_jump: bool = true
var knockback_velocity: Vector2 = Vector2.ZERO
var direction: float = 0.0
var original_speed: float = SPEED

var dashing = false
var can_dash = true  # New flag to control dash ability

func _ready() -> void:
	coyote_timer.wait_time = COYOTE_TIME
	knockback_timer.wait_time = KNOCKBACK_STOP_DURATION
	knockback_timer.one_shot = true
	
	$Camera2D/CanvasLayer/Sprite2D.visible = false
	$RealmShift.set_tile_maps($"../TileMapLight", $"../TileMapDark")

func _physics_process(delta: float) -> void:
	$HealthComponent/Label2.text = str("VV: ", velocity.y)
	if not dashing:
		direction = Input.get_axis("move_left", "move_right")
		if Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y = JUMP_VELOCITY / 3

		if Input.is_action_just_pressed("jump") and (is_on_floor() or !coyote_timer.is_stopped()):
			if can_jump:
				velocity.y = JUMP_VELOCITY
				can_jump = false 
	
	# Update dash logic to check can_dash flag
	if not dashing and Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		SPEED = 600
		FALL_GRAVITY = 0
		velocity.y = 0
		dash_timer.start()  # Start the dash timer
		can_dash = false  # Disable dashing until grounded

	if not is_on_floor():
		velocity.y += get_gravity(velocity) * delta

	if direction == 1: 
		sprite_2d.flip_h = false
	elif direction == -1:
		sprite_2d.flip_h = true
	if knockback_timer.is_stopped():
		velocity.x = direction * SPEED if direction != 0 else move_toward(velocity.x, 0, SPEED)

	velocity += knockback_velocity
	knockback_velocity *= KNOCKBACK_DECAY
	
	if is_on_floor():
		knockback_velocity.y = 0
		can_dash = true  # Reset dash ability when grounded

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
	return -1 if sprite_2d.flip_h else 1

func get_gravity(_velocity: Vector2) -> float:
	return FALL_GRAVITY if velocity.y >= 0 else gravity

func knockback(force: float, _x_pos: float, up_force: float) -> void:
	var multiplier := KNOCKBACK_MULTIPLIER_STANDING if direction == 0 else KNOCKBACK_MULTIPLIER_MOVING
	knockback_velocity = Vector2(force * multiplier * -get_direction(), -force * up_force)
	velocity.x = 0
	knockback_timer.start()

func _on_knockback_timer_timeout() -> void:
	velocity.x = direction * (SPEED * (RUN_MULTIPLIER if direction != 0 else 1.0))

func _on_dash_timer_timeout() -> void:
	dashing = false
	SPEED = 200
	FALL_GRAVITY = 980
