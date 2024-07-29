extends StaticBody2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var area_2d: Area2D = $Area2D

var entity: CharacterBody2D
var is_player_on: bool = false

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("down_platform") and is_player_on:
		entity.position.y += 1
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		entity = body
		is_player_on = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_on = false
