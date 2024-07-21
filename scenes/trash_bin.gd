extends PanelContainer

class_name TrashBin

signal item_dropped(item: InventoryItem)

func _ready() -> void:
	# Optional: Set visual appearance or interactable properties
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		var item = _get_drag_data(event.position)
		if item:
			emit_signal("item_dropped", item)
			item.queue_free()  # Optionally remove item from screen
