extends CharacterBody2D

var is_moving_left: bool = false

var gravity:float = 10
@export var items: Array[ItemData] = []
@export var drop_chance: float = 0.3
@export var friction: float = 20.0
@export var max_knockback_force: float = 500.0
@export var knockback_strength: float = 10.0
@export var knockback_damping: float = 0.5

var knockback_value: Vector2 = Vector2.ZERO
var knockback_duration: float = 0.1
var speed: float = 32
var player_entered: bool = true

func _ready() -> void:
	$AnimationPlayer.play("walk")
	$HealthComponent.connect("health_changed", self.handle_damage)
	
func handle_damage()-> void:
	$AnimationPlayer2.play("hit")
	
func _process(delta: float) -> void:
	if knockback_duration > 0:
		# Apply knockback effect
		velocity += knockback_value
		knockback_duration -= delta
		if knockback_duration <= 0:
			knockback_value = lerp(knockback_value, Vector2.ZERO, knockback_damping)
	else:
		# Apply regular gravity
		if not is_on_floor():
			velocity.y += gravity * delta
		# Apply a small horizontal drag if airborne
		velocity.x = lerp(velocity.x, 0.0, friction * delta)
	
	move_character()
	detect_turn_around()

func move_character() -> void:
	if knockback_duration <= 0:
		velocity.x = -speed if is_moving_left else speed
	
	# Apply gravity
	velocity.y += gravity
	
	# Move and slide with the current velocity
	if $AnimationPlayer.current_animation != "attack":
		$AnimationPlayer.play("walk")
	move_and_slide()

func detect_turn_around() -> void:
	if not $RayCast2D.is_colliding() and is_on_floor():
		is_moving_left = !is_moving_left
		scale.x = -scale.x
	if $RayCast2D2.is_colliding():
		var entity:Node2D = $RayCast2D2.get_collider()
		if not entity.is_in_group("player"):
			is_moving_left = !is_moving_left
			scale.x = -scale.x
			
	if $RayCast2D3.is_colliding():
		var entity: Node2D = $RayCast2D3.get_collider()
		if entity.is_in_group("player"):
			is_moving_left = !is_moving_left
			scale.x = -scale.x

func hit() -> void:
	$AttackDetector.monitoring = true

func end_of_hit()-> void:
	$AttackDetector.monitoring = false

func start_walk() -> void:
	$AnimationPlayer.play("walk")

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
		knockback_value.x *= 0.5

	knockback_value.y = -up_force

	# Reset knockback duration
	knockback_duration = 0.1

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_entered = true
		$AnimationPlayer.play("attack")

func _on_player_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_entered = false

func die() -> void:
	call_deferred("_drop_item")
	queue_free()

func _drop_item() -> void:
	if items.size() > 0:
		if randf() < drop_chance:
			var random_index: int = randi() % items.size()
			var item_data: ItemData = items[random_index]
			
			if item_data:
				var item_scene: PackedScene = preload("res://scenes/pickupable_items/sub_spells/collectible_sub_spell.tscn")
				if item_scene:
					var item_instance: Node = item_scene.instantiate()
					item_instance.set("item", item_data)
					
					item_instance.global_position = global_position
					
					get_tree().current_scene.add_child(item_instance)

func _on_attack_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var attack := Attack.new()
		attack.attack_damage = 30
		body.get_node("HealthComponent").damage(attack)
	
		var knockback_force: float = 300.0  # Adjust this value as needed
		body.knockback(knockback_force, global_position.x, 0)
