extends PanelContainer
class_name InventorySlot

@export var type: ItemData.Type
var background_texture: Texture = preload("res://assets/invslot.png")

func init(t: ItemData.Type, cms: Vector2, bg_texture: Texture = null) -> void:
	type = t
	custom_minimum_size = cms
	background_texture = bg_texture
	
	# Add a TextureRect for the background
	var bg: TextureRect = TextureRect.new()
	bg.expand = true
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	bg.texture = background_texture
	add_child(bg)
	#bg.move_child(get_child(0), 1)  # Ensure the background is behind other elements

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is InventoryItem:
		return type == data.data.type
	return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	# Check if the slot already has an item
	for child in get_children():
		if child is InventoryItem and child != data:
			child.reparent(data.get_parent())
	data.reparent(self)
