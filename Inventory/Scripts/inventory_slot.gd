extends PanelContainer
class_name InventorySlot

@export var type: ItemData.Type

func init(t: ItemData.Type, cms: Vector2) -> void:
	type = t
	custom_minimum_size = cms

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data is InventoryItem:
		return type == data.data.type
	return false

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if get_child_count() > 0:
		var item := get_child(0)
		if item == data:
			return
		item.reparent(data.get_parent())
	data.reparent(self)