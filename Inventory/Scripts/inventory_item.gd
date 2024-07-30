extends TextureRect
class_name InventoryItem

@export var data: ItemData
var dragged_from_hotbar: bool = false  # Track if the item was dragged from hotbar
var tooltip: Control  # Reference to the custom tooltip

func init(d: ItemData) -> void:
	data = d

func _ready() -> void:
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	if data:
		texture = data.texture
		create_tooltip()
	# Connect signals for mouse entered and exited
	connect("mouse_entered", Callable(self._on_mouse_entered))
	connect("mouse_exited", Callable(self._on_mouse_exited))

func _get_drag_data(at_position: Vector2) -> Variant:
	dragged_from_hotbar = get_parent().is_hotbar
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

func create_tooltip() -> void:
	var tooltip_scene = preload("res://scenes/tooltip.tscn")
	tooltip = tooltip_scene.instantiate()
	tooltip.set("text", "%s\n%s" % [data.name, data.description])
	add_child(tooltip)
	tooltip.visible = false

func _on_mouse_entered() -> void:
	tooltip.visible = true
	update_tooltip_position()

func _on_mouse_exited() -> void:
	tooltip.visible = false

func _process(delta: float) -> void:
	if tooltip.visible:
		update_tooltip_position()

func update_tooltip_position() -> void:
	var global_mouse_pos = get_global_mouse_position()
	var tooltip_size = tooltip.custom_minimum_size
	var tooltip_offset = Vector2(-125, -75)  # Adjust this value as needed

	# Position the tooltip slightly offset from the mouse position
	tooltip.position = tooltip_offset

