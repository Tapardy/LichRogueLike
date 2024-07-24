extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const COYOTE_TIME = 0.1  # Time in seconds to allow jumps after leaving the ground
const FALL_GRAVITY := 980
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var coyote_timer: Timer = $CoyoteTimer
var can_move: bool = true
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_jump: bool = true

func _ready() -> void:
	coyote_timer.wait_time = COYOTE_TIME 
	$Camera2D/CanvasLayer/Sprite2D.visible = false
	$RealmShift.set_tile_maps($"../TileMapLight", $"../TileMapDark")
	
func _physics_process(delta: float) -> void:
	#debug
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
			
	var direction: float = Input.get_axis("move_left", "move_right")
	if direction > 0:
		sprite_2d.flip_h = false
	elif direction < 0:
		sprite_2d.flip_h = true
		
	if direction:
		if Input.is_action_pressed("run"):
			velocity.x = direction * (SPEED * 1.75)
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
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
	
