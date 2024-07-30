extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.get_node("RealmShift").is_in_light = true
		body.get_node("RealmShift").change_realm(false)


func _on_body_exited(body: Node2D) -> void:

	if body.is_in_group("player"):
		body.get_node("RealmShift").is_in_light = false
