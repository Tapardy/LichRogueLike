extends Camera2D

# Export variable to control the intensity of the shake
@export var shake_intensity: float = 10.0

# Variable to track the shake duration
var shake_duration: float = 0.0

# Original position of the camera to restore after shaking
var original_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_position = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake_duration > 0:
		# Apply a random offset to the camera's position
		position = original_position + Vector2(randf_range(-1, 1), randf_range(-1, 1)) * shake_intensity
		shake_duration -= delta
	else:
		# Restore the original position when shaking is done
		position = original_position

# Public function to start the camera shake
func shake_camera(duration: float) -> void:
	shake_duration = duration
