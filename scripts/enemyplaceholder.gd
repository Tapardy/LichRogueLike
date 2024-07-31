extends CharacterBody2D

@export var items: Array[ItemData] = []
@export var drop_chance: float = 0.5
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var friction: float = 20.0
@export var max_knockback_force: float = 500.0  # Maximum allowable knockback force
@export var knockback_strength: float = 10.0   # Strength of knockback
@export var knockback_damping: float = 0.5     # Rate at which knockback reduces, higher for faster decay

var knockback_value: Vector2 = Vector2.ZERO
var knockback_duration: float = 0.1  # Duration for how long knockback should be applied
var speed: float = 100
# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity.y += gravity * delta
		# Apply a small horizontal drag if airborne
		velocity.x = lerp(velocity.x, 0.0, friction * delta)
	else:
		# Apply air resistance to horizontal velocity
		velocity.x = lerp(velocity.x, 0.0, friction * delta)

	# Move the enemy
	move_and_slide()


func die() -> void:
	queue_free()

#func _on_area_2d_body_entered(body: Node2D) -> void:
	#if body.is_in_group("player"):
		#if body.get_node("RealmShift").is_in_shadowrealm:
			#var attack := Attack.new()
			#attack.attack_damage = 10
			#body.get_node("HealthComponent").damage(attack)
		#
		#
			#var knockback_force: float = 300.0  # Adjust this value as needed
			#body.knockback(knockback_force, global_position.x, 0)
		
