extends Node2D

var direction: int = 0
var speed: float = 200.0  # Speed of the projectile
var entity: Node2D
var player: Node2D  # Reference to the player node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Find the player node in the scene tree
	player = find_player()

	if player:
		# Set direction based on the player's direction
		direction = player.get_direction()  # Ensure get_direction() is a valid function on the player node
		print("player direction: ", direction)

		# Flip the sprite based on direction
		if direction == -1:
			$AnimatedSprite2D.flip_h = true
		elif direction == 1:
			$AnimatedSprite2D.flip_h = false

		# Set the initial position of the projectile to be at the player's location
		global_position = player.global_position
	else:
		print("Player not found")


# Called at a fixed frame rate. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position.x += direction * speed * delta

func find_player() -> Node2D:
	# Traverse the scene tree to find the player node
	for node in get_tree().get_nodes_in_group("player"):
		if node.is_in_group("player"):
			return node
	return null

func deal_damage() -> void:
	var attack := Attack.new()
	attack.attack_damage = 15
	entity.get_node("HealthComponent").damage(attack)
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	entity = area.owner
	print(entity)
	if entity.is_in_group("enemies"):
		deal_damage()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		queue_free()
	print(body)
	if body.get_parent().get_parent().is_in_group("enemies"):
		print("hit an enemy")

func message():
	print("heyyo")
