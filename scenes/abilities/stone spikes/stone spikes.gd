extends Node2D

var direction: int = 0
var speed: float = 200.0  # Speed of the projectile
var entity: Node2D
var player: Node2D  # Reference to the player node


var base_damage: int = 20 
var damage: int = base_damage 
var base_size: Vector2 = Vector2(1, 1)
var size: Vector2 = base_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Find the player node in the scene tree
	player = find_player()
	
	if player:
		$AnimatedSprite2D/ImpactTimer.start()
		# Set direction based on the player's direction
		direction = player.get_direction()  # Ensure get_direction() is a valid function on the player node
		print("player direction: ", direction)
		
		# Calculate the scale factor and position adjustment
		var scale_factor: float = self.scale.x  # Assuming uniform scaling
		var offset: float = 40 * (0.75 * scale_factor)

		if direction == -1:
			global_position.x = player.global_position.x - offset
		elif direction == 1:
			global_position.x = player.global_position.x + offset

		# Adjust y position based on scale
		var y_offset: float = 20 * (scale_factor -0.2)  # Example adjustment
		global_position.y = player.global_position.y - y_offset

		$AnimatedSprite2D.play("default")
	else:
		print("Player not found")


func find_player() -> Node2D:
	for node in get_tree().get_nodes_in_group("player"):
		if node.is_in_group("player"):
			return node
	return null

#func _on_area_2d_area_entered(area: Area2D) -> void:
	#entity = area.owner
	#print(entity)
	#if entity.is_in_group("enemies"):
		#deal_damage()

func deal_damage() -> void:
	var attack := Attack.new()
	attack.attack_damage = damage
	print("damage dealt: ", damage)
	entity.get_node("HealthComponent").damage(attack)

func _on_area_2d_body_entered(body: Node2D) -> void:
	entity = body
	print(entity)
	if entity.is_in_group("enemies"):
		$AnimatedSprite2D.play("default")
		speed = 0
		$AnimatedSprite2D/ImpactTimer.start()
		deal_damage()

func set_damage(multiplier: float) -> void:
	print(multiplier)
	damage = base_damage * multiplier
	print("Damage set to: ", damage)

func get_damage() -> int:
	return damage

func set_size(new_size: Vector2) -> void:
	print(new_size)
	size = new_size
	self.scale = size
	print("Size set to: ", size)

func _on_impact_timer_timeout() -> void:
	queue_free()
