extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(_delta: float) -> void:
	$Label.text = str($HealthComponent.health)
