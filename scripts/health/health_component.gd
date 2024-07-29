extends Node2D

var health: int = 10
@export var suppress_damage: bool = false
@export var max_health: int = 10

signal health_changed
signal player_damaged
signal player_death

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health
		
func damage(attack: Attack) -> void:
	if not suppress_damage:
		if get_parent().is_in_group("player"):
			emit_signal("player_damaged")
			
		health -= attack.attack_damage
		emit_signal("health_changed")
		if health <= 0:
			if get_parent().is_in_group("enemies"):
				get_parent().die()
			else:
				get_parent().die()

func heal(amount: int) -> void:
	health += amount
	health = min(health, max_health)
	emit_signal("health_changed")

func update_hp() -> void:
	emit_signal("health_changed")

func is_max_hp() -> bool:
	return health >= max_health

func damage_self(self_damage: int) -> void:
	# Drain life force first
	var drained_life_force: int = $"../LifeForce".cast_spell_with_life_force(self_damage)
	var remaining_self_damage: int = self_damage - drained_life_force
	if remaining_self_damage > 0:
		var attack: Attack = Attack.new()
		attack.attack_damage = remaining_self_damage

		damage(attack)

		

# New function to check if the player can cast the spell
func can_cast_spell(self_damage: int) -> bool:
	var combined_health_life_force: int = health + $"../LifeForce".current_life_force
	return combined_health_life_force > self_damage  # Ensure health does not drop to or below zero
