extends CharacterBody2D

@export var attack_damage: float = 40
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	set_physics_process(false)
	$Label.text = str($HealthComponent.health)
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var attack := Attack.new()
		attack.attack_damage = attack_damage
		body.get_node("HealthComponent").damage(attack)
	
func _process(delta: float) -> void:
	$Label.text = str($HealthComponent.health)

func die() -> void:
	$"You won".player_won()

