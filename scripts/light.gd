extends Node2D

func _on_area_2d_body_entered(body):
	print(body)
	if body.is_in_group("player"):
		print("you are in the light")
		
		body.get_node("RealmShift").change_realm(false)
