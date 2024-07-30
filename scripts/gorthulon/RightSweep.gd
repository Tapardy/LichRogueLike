extends States



# Flag to prevent multiple transitions
var has_transitioned: bool = false

func enter() -> void:
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("Right sweep")
	has_transitioned = false


func transition() -> void:
	if has_transitioned:
		get_parent().change_state("Idle")

	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	has_transitioned = true
	transition()  # Call transition to change the state
		# Optionally disconnect the signal here to avoid future triggers
