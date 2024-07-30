extends Area2D
@export var contact_damage: int = 20


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		
		var attack := Attack.new()
		attack.attack_damage = contact_damage
		body.get_node("HealthComponent").damage(attack)
	
	
		var knockback_force: float = 300.0  # Adjust this value as needed
		body.knockback(knockback_force, global_position.x, 0)
