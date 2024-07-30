extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ghosting()

func set_property(tx_pos: Vector2, tx_scale: Vector2, _tx_texture: Texture2D, tx_flip_h: bool, frame_rect: Rect2) -> void:
	var adjusted_position: Vector2 = tx_pos + Vector2(0, -7)  # Adjust the y-position by the required value
	position = adjusted_position
	scale = tx_scale
	self.flip_h = tx_flip_h
	texture = _tx_texture
	region_enabled = true
	region_rect = frame_rect

func ghosting() -> void:
	var tween_fade: Tween = get_tree().create_tween()
	tween_fade.tween_property(self, "self_modulate", Color(1, 1, 1, 0), 0.75)
	await tween_fade.finished
	queue_free()
