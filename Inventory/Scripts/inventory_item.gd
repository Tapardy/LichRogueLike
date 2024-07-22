extends TextureRect
class_name InventoryItem

@export var data: ItemData
var dragged_from_hotbar: bool = false  # Track if the item was dragged from hotbar

func init(d: ItemData) -> void:
	data = d

func _ready() -> void:
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	if data:
		texture = data.texture
		tooltip_text = "%s\n%s" % [data.name, data.description]

func _get_drag_data(at_position: Vector2) -> Variant:
	dragged_from_hotbar = get_parent().is_hotbar
	print(dragged_from_hotbar)
	set_drag_preview(make_drag_preview(at_position))
	return self

func make_drag_preview(at_position: Vector2) -> Variant:
	var t: TextureRect = TextureRect.new()
	t.texture = texture
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.custom_minimum_size = size
	t.modulate.a = 0.5
	t.position = Vector2(-at_position)
	t.z_index = 1000
	var c: Control = Control.new()
	c.add_child(t)
	
	return c
