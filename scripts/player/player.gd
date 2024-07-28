extends CharacterBody2D

var speed: float = 200.0
const RUN_MULTIPLIER: float = 1.25
var jump_velocity: float = -450.0
const COYOTE_TIME: float = 0.1
var fall_gravity: float = 1300
const KNOCKBACK_DECAY: float = 0.8
const KNOCKBACK_MULTIPLIER_STANDING: float = 0.5
const KNOCKBACK_MULTIPLIER_MOVING: float = 0.5
const KNOCKBACK_STOP_DURATION: float = 0.1

@export var ghost_node: PackedScene
@export var jump_buffer_time: float = 0.03

@onready var ghost_timer: Timer = $Sprite2D/GhostTimer
@onready var invincible_timer: Timer = $InvincibleTimer

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var knockback_timer: Timer = $PlayerAttack/KnockbackTimer
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer  # New timer for dash cooldown

var can_move: bool = true
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_jump: bool = true
var knockback_velocity: Vector2 = Vector2.ZERO
var direction: float = 0.0
var original_speed: float = speed

var can_dash: bool = true  # New flag to control dash ability
var jump_buffer: bool = false

var is_jumping: bool = false
var is_moving: bool = false
var dashing: bool = false
var is_attacking: bool = false
var invincible: bool = false
var base_collision_layer: int = self.collision_layer

func _ready() -> void:
	$HealthComponent.connect("player_damaged", give_iframes)
	coyote_timer.wait_time = COYOTE_TIME
	knockback_timer.wait_time = KNOCKBACK_STOP_DURATION
	knockback_timer.one_shot = true
	dash_cooldown_timer.one_shot = true  # Ensure the cooldown timer is one-shot
	
	$Camera2D/CanvasLayer/Sprite2D.visible = false
	$RealmShift.set_tile_maps($"../TileMapLight", $"../TileMapDark", $"../TileMapLight/ParallaxForestLight")

func change_parallax(light: ParallaxBackground, dark: ParallaxBackground) -> void:
	$RealmShift.set_parallax(light,dark)
	
func _physics_process(delta: float) -> void:
	$HealthComponent/Label2.text = str("VV: ", velocity.y)
	
	var was_on_floor: bool = is_on_floor()
	
	if not dashing:
		direction = Input.get_axis("move_left", "move_right")
		is_moving = direction != 0  # Update moving flag
		if Input.is_action_just_pressed("jump") and (is_on_floor() or !coyote_timer.is_stopped()):
			if can_jump:
				jump()
			else:
				jump_buffer = true
				get_tree().create_timer(jump_buffer_time).timeout.connect(on_jump_buffer_timeout)
	# Update dash logic to check can_dash flag
	if not dashing and Input.is_action_just_pressed("dash") and can_dash and direction != 0:
		ghost_timer.start()
		
		dashing = true
		speed = 500
		fall_gravity = 0
		velocity.y = 0
		dash_timer.start()  # Start the dash timer
		dash_cooldown_timer.start()  # Start the cooldown timer
		can_dash = false  # Disable dashing until the cooldown is over
		
	if not is_on_floor():
		velocity.y += get_gravity(velocity) * delta
		
	if direction == 0 and not $PlayerAttack.currently_attacking() or !$SpellCasting.get_cast_status():
		$AnimationPlayer.play("idle")
	if direction == 1: 
		sprite_2d.flip_h = false
	elif direction == -1:
		sprite_2d.flip_h = true
		
	if knockback_timer.is_stopped():
		velocity.x = direction * speed if direction != 0 else move_toward(velocity.x, 0, speed)
		
	velocity += knockback_velocity
	knockback_velocity *= KNOCKBACK_DECAY
	
	if is_on_floor():
		knockback_velocity.y = 0
		
	move_and_slide()
	
	if was_on_floor and not is_on_floor():
		coyote_timer.start()
	elif is_on_floor():
		can_jump = true
		is_jumping = false  # Update jumping flag
		coyote_timer.stop()
		if jump_buffer:
			jump()
			jump_buffer = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("realm_shift"):
		$RealmShift.handle_realm_shift()
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = velocity.y * 0.2  # Prevent extra height gain
		



func jump() -> void:
	velocity.y = jump_velocity
	can_jump = false 
	is_jumping = true  # Update jumping flag
func change_realm(value: int) -> void:
	$RealmShift.change_realm(value)

func _on_coyote_timer_timeout() -> void:
	can_jump = false

func get_direction() -> int:
	return -1 if sprite_2d.flip_h else 1

func get_gravity(_velocity: Vector2) -> float:
	return fall_gravity if velocity.y >= 0 else gravity

func knockback(force: float, _x_pos: float, up_force: float) -> void:
	var multiplier := KNOCKBACK_MULTIPLIER_STANDING if direction == 0 else KNOCKBACK_MULTIPLIER_MOVING
	knockback_velocity = Vector2(force * multiplier * -get_direction(), -force * up_force)
	velocity.x = 0
	knockback_timer.start()
	dash_timer.stop()  # Stop dash timer when knockback occurs
	# Ensure to stop dashing and reset dash parameters
	_on_dash_timer_timeout()

func _on_knockback_timer_timeout() -> void:
	velocity.x = direction * (speed * (RUN_MULTIPLIER if direction != 0 else 1.0))

func _on_dash_timer_timeout() -> void:
	dashing = false
	ghost_timer.stop()
	speed = 200
	fall_gravity = 980

func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true

func add_ghost() -> void:
	var ghost: Node2D = ghost_node.instantiate()
	ghost.set_property(position, $Sprite2D.scale, $Sprite2D.texture, $Sprite2D.flip_h)
	get_tree().current_scene.add_child(ghost)

func give_iframes() -> void:
	self.collision_layer = 0
	invincible = true
	$HealthComponent.suppress_damage = true
	$InvincibleTimer.start()

func _on_ghost_timer_timeout() -> void:
	add_ghost()

func on_jump_buffer_timeout()-> void:
	jump_buffer = false

func _on_invincible_timer_timeout() -> void:
	invincible = false
	$HealthComponent.suppress_damage = false
	self.collision_layer = base_collision_layer



