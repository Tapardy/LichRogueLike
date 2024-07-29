extends Control


func player_died() -> void:
	$CanvasLayer.visible = true
	get_tree().paused = true

func _on_button_2_pressed() -> void:
	
	get_tree().paused = false
	get_tree().change_scene_to_packed(load("res://scenes/levels/loadingscreen.tscn"))


