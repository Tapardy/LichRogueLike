extends Area2D


func _on_area_entered(area: Area2D) -> void:
	area.position.y = -15
	area.position.x = 0


func _on_body_entered(body: Node2D) -> void:
	body.position.y = -15
	body.position.x = 0
