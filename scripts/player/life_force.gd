extends Node2D

var max_life_force: int = 99
var current_life_force: int = 0
var heal_threshold: int = 33
var heal_amount: int = 25
var life_from_hit: int = 11

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_life_force = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	current_life_force = clamp(current_life_force, 0, max_life_force)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("heal"):
		if current_life_force >= heal_threshold:
			heal()

func add_life_force() -> void:
	current_life_force += life_from_hit

func heal() -> void:
	if not $"../HealthComponent".is_max_hp():
		print("life force before heal ", current_life_force)
		current_life_force -= heal_threshold
		print("just healed, current life force ", current_life_force)
		$"../HealthComponent".heal(heal_amount)
	print("max hp")

# Returns the remaining life force after the initial value
func cast_spell_with_life_force(cast_cost: int) -> int:
	var remaining_life_force = current_life_force - cast_cost
	if remaining_life_force < 0:
		var life_force_drained = current_life_force
		current_life_force = 0
		return life_force_drained
	else:
		current_life_force = remaining_life_force
		return cast_cost
