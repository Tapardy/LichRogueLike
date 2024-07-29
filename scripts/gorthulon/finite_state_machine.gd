extends Node2D

var current_state: States
var previous_state: States

func _ready() -> void:
	current_state = get_child(0) as States
	previous_state = current_state
	current_state.enter()


func change_state(state)-> void:
	current_state = find_child(state) as States
	current_state.enter()
	
	previous_state.exit()
	previous_state = current_state
