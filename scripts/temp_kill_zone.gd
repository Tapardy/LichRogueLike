extends Area2D
@export var playerPositionY: float = -15
@export var playerPositionX: float = 0

func _on_area_entered(area: Area2D) -> void:
	area.position.y = playerPositionY
	area.position.x = playerPositionX


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		
		var attack := Attack.new()
		attack.attack_damage = 40
		body.get_node("HealthComponent").damage(attack)
		body.position.y = playerPositionY
		body.position.x = playerPositionX
	
	if body.is_in_group("enemies"):
		queue_free()
