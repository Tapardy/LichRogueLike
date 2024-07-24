extends Node2D
@onready var sprite_2d: Sprite2D = $"../Sprite2D"
@export var melee_damage: int = 10
var entity: Node2D
var actual_damage: float
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
		$MeleeAttack.flip_h = false
		$MeleeAttack.position.x = sprite_2d.position.x - 28
	else:
		$MeleeAttack.flip_h = true
		$MeleeAttack.position.x = sprite_2d.position.x + 32
#
func _on_melee_hitbox_area_entered(area: Node2D) -> void:
	print(area.owner)
	entity = area
	if entity.is_in_group("enemies"):
		deal_damage()
	
func deal_damage() -> void:
	var attack := Attack.new()
	if $"../RealmShift".is_in_shadowrealm:
		actual_damage = melee_damage * $"../RealmShift".shadow_strength
		print ($"../RealmShift".shadow_strength)
		print("shadow: " , melee_damage)
	else:
		actual_damage = melee_damage * $"../RealmShift".light_strength
		print("light: " , melee_damage)
	attack.attack_damage = actual_damage
	print(actual_damage)
	entity.get_node("HealthComponent").damage(attack)
	$"../LifeForce".add_life_force()

func damage_self() -> void:
	var attack := Attack.new()
	# Subject to change, due to the transmutation spell self damage
	attack.attack_damage = melee_damage
	$"../HealthComponent".damage(attack)


func _on_melee_hitbox_body_entered(body: Node2D) -> void:
	print(body)
	entity = body
	if body.is_in_group("enemies"):
		deal_damage()
