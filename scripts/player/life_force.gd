extends Node2D

var max_life_force: int = 99
var current_life_force: int = 0
var heal_threshold: int = 33
var heal_amount: int = 33
var life_from_hit: int = 11
signal life_force_changed

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
	current_life_force = clamp(current_life_force + life_from_hit, 0, max_life_force)
	emit_signal("life_force_changed")

func heal() -> void:
	if not $"../HealthComponent".is_max_hp():
		print("life force before heal ", current_life_force)
		current_life_force = clamp(current_life_force - heal_threshold, 0, max_life_force)
		print("just healed, current life force ", current_life_force)
		$"../HealthComponent".heal(heal_amount)
		emit_signal("life_force_changed")
	else:
		print("max hp")

# Returns the remaining life force after the initial value
func cast_spell_with_life_force(cast_cost: int) -> int:
	var remaining_life_force: float = current_life_force - cast_cost
	if remaining_life_force < 0:
		var life_force_drained: float = current_life_force
		current_life_force = 0
		emit_signal("life_force_changed")
		return life_force_drained
	else:
		current_life_force = clamp(remaining_life_force, 0, max_life_force)
		emit_signal("life_force_changed")
		return cast_cost
