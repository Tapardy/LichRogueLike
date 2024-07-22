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
		return type == data.data.type or is_special
	return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	# Check if the data is an InventoryItem
	if data is InventoryItem:
		var item = data as InventoryItem

		# If this is a special slot, delete the item and clean up
		if is_special:
			# Check if InventoryManager is available
			var manager := get_parent().get_parent() as InventoryManager
			
			if manager:
				manager.remove_item(item)
			else:
				print_debug("Warning: InventoryManager not found. Item will not be removed from the global inventory.")

			# Clear any existing items from this slot
			for child in get_children():
				if child is InventoryItem:
					# Ensure the item is still a child before removing
					if child.get_parent() == self:
						remove_child(child)
					child.queue_free()

			# Ensure the item being dropped is not already a child before removing
			if item.get_parent() == self:
				remove_child(item)
			item.queue_free()
		else:
			# If not a special slot, reparent the item to this slot
			if item.get_parent() != self:
				item.reparent(self)
