extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	if body.is_in_group("player"):
		print("You are in the light")
		body.get_node("RealmShift").change_realm(false)
		body.get_node("RealmShift").is_in_light = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	print(body)
	if body.is_in_group("player"):
		print("You are not in the light")
		body.get_node("RealmShift").is_in_light = false
