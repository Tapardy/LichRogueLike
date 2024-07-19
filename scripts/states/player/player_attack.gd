extends State
class_name PlayerAttacking

@export var player: CharacterBody2D
@export var melee_damage: int = 10
var entity: Node2D
@onready var sprite_2d = $"../../Sprite2D"
@onready var attack_duration = $"../../PlayerAttack/AttackDuration"

func enter()-> void:
	$"../../PlayerAttack/MeleeAttack".visible = true
	perform_melee_attack()
	attack_duration.start()

func exit()-> void:
	$"../../PlayerAttack/MeleeAttack".visible = false

func update(delta: float)-> void:
	if attack_duration.is_stopped():
		Transitioned.emit(self, "idle")

func physics_update(delta: float)-> void:
	# Optionally handle any physics-related logic while in attacking state
	pass

func perform_melee_attack() -> void:
	$"../../AnimationPlayer".play("attack")

	if sprite_2d.flip_h:
		$"../../PlayerAttack/MeleeAttack".flip_h = true
		$"../../PlayerAttack/MeleeAttack".position.x = sprite_2d.position.x + 32
	else:
		$"../../PlayerAttack/MeleeAttack".flip_h = false
		$"../../PlayerAttack/MeleeAttack".position.x = sprite_2d.position.x - 28

func _on_melee_hitbox_area_entered(area) -> void:
	entity = area.owner
	if entity.is_in_group("enemies"):
		deal_damage()

func deal_damage() -> void:
	var attack = Attack.new()
	attack.attack_damage = melee_damage
	print("Dealing damage:", melee_damage)
	entity.get_node("HealthComponent").damage(attack)
