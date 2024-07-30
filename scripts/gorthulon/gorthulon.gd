extends CharacterBody2D

@export var attack_damage: float = 40
var attack_position: Vector2

func _ready() -> void:
	set_physics_process(false)

	attack_position = global_position  # Initialize attack_position

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var attack := Attack.new()
		attack.attack_damage = attack_damage
		body.get_node("HealthComponent").damage(attack)
		var knockback_force: float = 400.0  # Adjust this value as needed

		if $AnimationPlayer.current_animation == "Left sweep":
			attack_position.x = global_position.x - 300  # Set attack_position for left sweep
		elif $AnimationPlayer.current_animation == "Right sweep":
			attack_position.x = global_position.x + 300  # Set attack_position for right sweep
		else:
			attack_position.x = global_position.x

		body.knockback(knockback_force, attack_position.x, 0)

	

func die() -> void:
	$"You won".player_won()

