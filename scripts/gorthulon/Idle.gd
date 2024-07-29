extends States

@onready var collision_shape_2d: CollisionShape2D = $"../../PlayerDetection/CollisionShape2D"
@onready var hp: TextureProgressBar = $"../../HP"
@onready var attack_cooldown_timer: Timer = $"../../AttackCooldown"

var states = ["LeftSweep", "RightSweep", "Tongue"]
var initial_trigger: bool = true
var timer_went: bool = false

func _ready() -> void:
	randomize()
	# No need to connect signals manually, assumed to be connected in the editor

func enter() -> void:
	super.enter()
	owner.set_physics_process(true)
	if not initial_trigger:
		animation_player.play("Idle 1x")
		attack_cooldown_timer.start()

func transition() -> void:
	if timer_went:  # Ensure the timer has finished
		var random_state = states[randi() % states.size()]
		get_parent().change_state(random_state)
		timer_went = false  # Reset the flag

func _on_attack_cooldown_timeout() -> void:
	timer_went = true
	attack_cooldown_timer.wait_time = 1.2
	transition()  # Trigger transition after cooldown

func _on_player_detection_body_entered(body: Node2D) -> void:
	print("kanker")
	if body.is_in_group("player"):
		var camera: Camera2D = body.get_node("Camera2D")
		if initial_trigger:
			camera.position.y -= 50
			initial_trigger = false
			attack_cooldown_timer.start()  # Start the timer on the first detection
			collision_shape_2d.set_deferred("disabled", true)  # Disable the hitbox
