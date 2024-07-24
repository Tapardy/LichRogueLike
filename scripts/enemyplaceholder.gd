extends CharacterBody2D

@export var items: Array[ItemData] = []
@export var drop_chance: float = 0.5
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var friction: float = 20.0
@export var max_knockback_force: float = 500.0  # Maximum allowable knockback force
@export var knockback_strength: float = 10.0   # Strength of knockback
@export var knockback_damping: float = 0.5     # Rate at which knockback reduces, higher for faster decay

var knockback_value: Vector2 = Vector2.ZERO
var knockback_duration: float = 0.1  # Duration for how long knockback should be applied
var speed: float = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(self.position, self.global_position)

func _physics_process(delta: float) -> void:
	$Label.text = str($HealthComponent.health)
	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity.y += gravity * delta
		# Apply a small horizontal drag if airborne
		velocity.x = lerp(velocity.x, 0.0, friction * delta)
	else:
		# Apply air resistance to horizontal velocity
		velocity.x = lerp(velocity.x, 0.0, friction * delta)

	# Apply knockback
	if knockback_duration > 0:
		velocity += knockback_value
		knockback_duration -= delta  # Decrease the knockback duration

	# Move the enemy
	move_and_slide()

	# Lerp knockback vector back to zero if needed
	if knockback_duration <= 0:
		knockback_value = lerp(knockback_value, Vector2.ZERO, knockback_damping)

func knockback(force: float, x_pos: float, up_force: float) -> void:
	# Cap the knockback force
	force = clamp(force, -max_knockback_force, max_knockback_force)
	
	# Determine horizontal knockback direction
	if x_pos < global_position.x:
		knockback_value.x = force
	else:
		knockback_value.x = -force

	# Apply a reduced horizontal force if not on the ground
	if not is_on_floor():
		knockback_value.x *= 0.5  # Reduce horizontal force by half if in the air

	# Apply vertical knockback
	knockback_value.y = -up_force

	# Reset knockback duration
	knockback_duration = 0.1  # Adjust this value to control how long knockback lasts

func die() -> void:
	call_deferred("_drop_item")
	queue_free()

func _drop_item() -> void:
	if items.size() > 0:
		# Determine if an item should be dropped based on the drop chance
		if randf() < drop_chance:
			# Choose a random item from the array
			var random_index: int = randi() % items.size()
			var item_data: ItemData = items[random_index]
			
			if item_data:
				var item_scene: PackedScene = preload("res://scenes/pickupable_items/main_spells/collectible_main_spell.tscn")
				if item_scene:
					var item_instance: Node = item_scene.instantiate()
					item_instance.set("item", item_data)
					
					item_instance.global_position = global_position
					
					get_tree().current_scene.add_child(item_instance)
