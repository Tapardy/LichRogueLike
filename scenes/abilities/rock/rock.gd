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
		$DeletionTimer.start()
		# Set direction based on the player's direction
		direction = player.get_direction()  # Ensure get_direction() is a valid function on the player node
		print("player direction: ", direction)
		
		# Flip the sprite based on direction
		if direction == -1:
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D/Area2D.position.x -= 15
		elif direction == 1:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D/Area2D.position.x += 15
		
		# Set the initial position of the projectile to be at the player's location
		global_position = player.global_position
	else:
		print("Player not found")

func _physics_process(delta: float) -> void:
	global_position.x += direction * speed * delta

func find_player() -> Node2D:
	for node in get_tree().get_nodes_in_group("player"):
		if node.is_in_group("player"):
			return node
	return null

#func _on_area_2d_area_entered(area: Area2D) -> void:
	#entity = area.owner
	#print(entity)
	#if entity.is_in_group("enemies"):
		#$AnimatedSprite2D.play("Impact")
		#speed = 0
		#$AnimatedSprite2D/ImpactTimer.start()
		#deal_damage()

func deal_damage() -> void:
	var attack := Attack.new()
	attack.attack_damage = damage
	entity.get_node("HealthComponent").damage(attack)
	if entity.has_method("knockback"):
		entity.knockback(75.0, global_position.x, 0)

func _on_area_2d_body_entered(body: Node2D) -> void:
	entity = body
	if entity.is_in_group("enemies"):
		$AnimatedSprite2D.play("Impact")
		speed = 0
		$AnimatedSprite2D/ImpactTimer.start()
		deal_damage()

func set_damage(multiplier: float) -> void:
	damage = base_damage * multiplier

func get_damage() -> int:
	return damage

func set_size(new_size: Vector2) -> void:
	size = new_size
	self.scale = size


func _on_deletion_timer_timeout() -> void:
	queue_free()


func _on_impact_timer_timeout() -> void:
	queue_free()
