extends Node2D

@onready var sprite_2d: Sprite2D = $"../Sprite2D"
@export var melee_damage: int = 10
var entity: Node2D
var actual_damage: float
var hit_registered: bool = false  # Track if a hit has been registered during the current attack

func _ready() -> void:
	$MeleeAttack.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("melee_attack"):
		perform_melee_attack()

func perform_melee_attack() -> void:
	$"../AnimationPlayer".play("attack")
	
	if sprite_2d.flip_h:
		$MeleeAttack.flip_h = false
		$MeleeAttack.position.x = sprite_2d.position.x - 28
	else:
		$MeleeAttack.flip_h = true
		$MeleeAttack.position.x = sprite_2d.position.x + 32
	
	hit_registered = false  # Reset hit registration at the start of a new attack

func _on_melee_hitbox_area_entered(area: Node2D) -> void:
	if not hit_registered and area.is_in_group("enemies"):
		hit_registered = true
		entity = area
		deal_damage()

func _on_melee_hitbox_body_entered(body: Node2D) -> void:
	if not hit_registered and body.is_in_group("enemies"):
		hit_registered = true
		entity = body
		deal_damage()

func deal_damage() -> void:
	var attack := Attack.new()
	if $"../RealmShift".is_in_shadowrealm:
		actual_damage = melee_damage * $"../RealmShift".shadow_strength
		print($"../RealmShift".shadow_strength)
		print("shadow: ", melee_damage)
	else:
		actual_damage = melee_damage * $"../RealmShift".light_strength
		print("light: ", melee_damage)
	attack.attack_damage = actual_damage
	print(actual_damage)
	entity.get_node("HealthComponent").damage(attack)

	if entity.has_method("knockback"):
		entity.knockback(75.0, global_position.x, 0)
		
		# Apply knockback to the player
		var knockback_force: float = 100.0  # Adjust this value as needed
		var player: CharacterBody2D = get_parent()  # Adjust this path if necessary
		if player.has_method("knockback"):
			player.knockback(knockback_force, global_position.x, 0)

	$"../LifeForce".add_life_force()
