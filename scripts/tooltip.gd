extends Control

@export var padding: Vector2 = Vector2(10, 5)

var _text: String = ""
var label: Label
var background: ColorRect

@export var text: String:
	get:
		return _text
	set(value):
		_text = value
		update_tooltip()

func _ready() -> void:
	label = $Label
	background = $ColorRect
	if label == null or background == null:
		push_error("Label or ColorRect node is not found.")
	update_tooltip()

func update_tooltip() -> void:
	if label == null or background == null:
		return

	label.text = _text
	var label_size: Vector2 = label.get_minimum_size()
	var background_size: Vector2 = label_size + padding * 2

	# Update background size and position
	background.custom_minimum_size = background_size
	background.custom_minimum_size = background_size

	# Center the label within the background
	label.custom_minimum_size = label_size
	label.position = padding

	custom_minimum_size = background_size
