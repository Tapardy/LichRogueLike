extends Node2D

var health := 10 
@export var supress_damage: bool = false

@export var max_health := 10

signal health_changed
signal player_death
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health


func damage(attack: Attack) -> void:
	if supress_damage == false:
		health -= attack.attack_damage

		#print("health: ", health)
		emit_signal("health_changed")
		if health <= 0:
			get_parent().queue_free()

func heal() -> void:
	health = max_health
	emit_signal("health_changed")

func update_hp() -> void:
	emit_signal("health_changed")
