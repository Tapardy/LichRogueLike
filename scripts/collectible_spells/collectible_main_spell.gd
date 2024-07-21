extends RigidBody2D

@export var item: ItemData

func _ready() -> void:
	$Sprite2D.texture = item.texture
func _on_interactable_area_body_entered(body: Node2D) -> void:
	print(body)
	if body.is_in_group("player"):
		body.get_node("GUI").add_item_to_main(item.resource_path)
		queue_free()
