extends PanelContainer
class_name InventorySlot

@export var type: ItemData.Type
@export var is_hotbar: bool = false
var background_texture: Texture = preload("res://assets/invslot.png")
var special_texture: Texture = preload("res://assets/bin.png")
var is_special: bool = false

var dragged_from_hotbar: bool = false  

func init(t: ItemData.Type, cms: Vector2, bg_texture: Texture = null, special: bool = false) -> void:
	type = t
	custom_minimum_size = cms
	background_texture = bg_texture
	is_special = special
	
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

func is_occupied() -> bool:
	for child in get_children():
		if child is InventoryItem:
			return true
	return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if is_occupied():
		return 

	var manager := get_parent().get_parent() as InventoryManager

	if is_hotbar:
		manager = owner.get_node("GUI")
		data.reparent(self)
		
		if data.data.type == ItemData.Type.MAIN:
			manager.remove_item_from_main(data)
		elif data.data.type == ItemData.Type.SUB1:
			manager.remove_item_from_sub(data)
	else:
		if is_special:
			if manager:
				manager.remove_item(data)
				
		for child in get_children():
			if child is InventoryItem:
				child.queue_free()
				
		data.reparent(self)
		
		if data.dragged_from_hotbar:
			if type == ItemData.Type.MAIN:
				manager.add_item_to_main(data.data.resource_path)
			elif type == ItemData.Type.SUB1:
				manager.add_item_to_sub(data.data.resource_path)
