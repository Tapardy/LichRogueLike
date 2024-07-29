extends Node2D
class_name States
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func _ready() -> void:
	set_physics_process(false)
	
func enter() -> void:
	set_physics_process(true)
func exit()-> void:
	set_physics_process(false)
	
func transition() -> void:
	pass 
func _physics_process(_delta: float) -> void:
	transition()
