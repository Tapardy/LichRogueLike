extends Node2D
@onready var sprite_2d: Sprite2D = $"../Sprite2D"
@export var melee_damage: int = 10
var entity: Node2D

func _ready() -> void:
	$MeleeAttack.visible = false
	
func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
		#damage_self()
	if event.is_action_pressed("melee_attack"):
		#print("melee attack")
		perform_melee_attack()

func perform_melee_attack() -> void:
	$"../AnimationPlayer".play("attack")
	
	if sprite_2d.flip_h:
		$MeleeAttack.flip_h = true
		$MeleeAttack.position.x = sprite_2d.position.x + 32
	else:
		$MeleeAttack.flip_h = false
		$MeleeAttack.position.x = sprite_2d.position.x - 28

func _on_melee_hitbox_area_entered(area: Node2D) -> void:
	print(area.owner)
	entity = area.owner
	if entity.is_in_group("enemies"):
		deal_damage()
	
func deal_damage() -> void:
	var attack := Attack.new()
	attack.attack_damage = melee_damage
	print(melee_damage)
	entity.get_node("HealthComponent").damage(attack)
	$"../LifeForce".add_life_force()

func damage_self() -> void:
	var attack := Attack.new()
	# Subject to change, due to the transmutation spell self damage
	attack.attack_damage = melee_damage
	$"../HealthComponent".damage(attack)
