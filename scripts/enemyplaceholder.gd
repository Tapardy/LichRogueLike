extends RigidBody2D

@export var items: Array[ItemData] = []
@export var drop_chance: float = 0.5 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(self.position, self.global_position)

func _physics_process(_delta: float) -> void:
	$Label.text = str($HealthComponent.health)
	

func die() -> void:
	call_deferred("_drop_item")
	queue_free()

func _drop_item() -> void:
	if items.size() > 0:
		# Determine if an item should be dropped based on the drop chance
		if randf() < drop_chance:
			# Choose a random item from the array
			var random_index: float = randi() % items.size()
			var item_data: ItemData = items[random_index]
			
			if item_data:
				var item_scene: Resource = load("res://scenes/pickupable_items/main_spells/collectible_main_spell.tscn")
				if item_scene:
					var item_instance: Node = item_scene.instantiate()
					item_instance.item = item_data

					item_instance.global_position = global_position
					
					get_tree().current_scene.add_child(item_instance)
