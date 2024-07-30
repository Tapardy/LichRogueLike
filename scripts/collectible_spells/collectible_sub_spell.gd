extends StaticBody2D

@export var item: ItemData

func _ready() -> void:
	$Sprite2D.texture = item.texture
	
func _on_interactable_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var inventory_manager := body.get_node("GUI") as InventoryManager
		
		# Check if item can be added to the main inventory
		if inventory_manager.can_add_item_to_sub(item.resource_path):
			inventory_manager.add_item_to_sub(item.resource_path)
			queue_free()  # Remove the item from the scene
