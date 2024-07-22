extends PanelContainer
class_name InventorySlot

@export var type: ItemData.Type
var background_texture: Texture = preload("res://assets/invslot.png")
var special_texture: Texture = preload("res://assets/bin.png")
var is_special: bool = false  # Flag to identify if the slot is special

func init(t: ItemData.Type, cms: Vector2, bg_texture: Texture = null, special: bool = false) -> void:
	type = t
	custom_minimum_size = cms
	background_texture = bg_texture
	is_special = special
	
	# Add a TextureRect for the background
	var bg: TextureRect = TextureRect.new()
	bg.expand = true
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	bg.texture = background_texture
	add_child(bg)
	
	if is_special:
		set_special_icon()

func set_special_icon() -> void:
	if is_special:
		for child in get_children():
			if child is TextureRect:
				child.texture = special_texture

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is InventoryItem:
		return type == data.data.type
	return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	for child in get_children():
		if child is InventoryItem and child != data:
			child.reparent(data.get_parent())
	
	# Remove the item from its previous location
	if is_special:
		var manager := get_parent().get_parent() as InventoryManager
		if manager:
			manager.remove_item(data)
		
		# Clear any existing items from this slot
		for child in get_children():
			if child is InventoryItem:
				child.queue_free()
	
	# Add the new item
	data.reparent(self)

