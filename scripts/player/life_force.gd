extends Node2D

var max_life_force: int = 99

var current_life_force: int = 0
var heal_treshold: int = 33
var heal_amount: int = 25
var life_from_hit: int = 11
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if current_life_force > max_life_force:
		current_life_force = max_life_force
	#print(current_life_force)

func _input(event):
	if event.is_action_pressed("heal"):
		if current_life_force >= heal_treshold:
			heal()

func add_life_force():
	current_life_force += life_from_hit

func heal():
	if $"../HealthComponent".is_max_hp() == false:
		print("life force before heal ", current_life_force)
		current_life_force -= heal_treshold
		print("just healed, current life force ", current_life_force)
		$"../HealthComponent".heal(heal_amount)
		
	print("max hp")
