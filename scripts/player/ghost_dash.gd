extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ghosting()


func set_property(tx_pos: Vector2, tx_scale: Vector2, tx_texture: Texture2D):
	position = tx_pos
	scale = tx_scale
	texture = tx_texture
	
func ghosting():
	var tween_fade = get_tree().create_tween()
	
	tween_fade.tween_property(self, "self_modulate", Color(1, 1, 1, 0), 0.75)
	await  tween_fade.finished
	queue_free()
	