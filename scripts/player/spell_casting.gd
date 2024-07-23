extends Node2D

var cast_amount: int = 1
var timer: Timer
var casting: bool = false
var spell_modifications: Dictionary = {}

var final_self_damage: int = 0

@export var main_spell_self_damage: int = 10
@export var attack_up_self_damage: int = 15
@export var size_increase_self_damage: int = 10
@export var spell_dupe_self_damage: int = 15

var damage_up: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not timer:
		timer = Timer.new()
		timer.wait_time = 0.1
		timer.one_shot = true
		add_child(timer)

func load_ability(name: String) -> void:
	if casting:
		print("Already casting. Please wait until casting is finished.")
		return
		
	# Check if player can cast the spell
	if not $"../HealthComponent".can_cast_spell(final_self_damage):
		reset_spell_modifications()
		return
	
	$"../HealthComponent".damage_self(final_self_damage)
	
	casting = true  # Set casting flag to true

	print("cast_amount variable: ", cast_amount)
	var scene: PackedScene = load("res://scenes/abilities/" + name + "/" + name + ".tscn")
	
	# Get the player's parent node (which is the root node or any sibling container)
	var player_sibling_container: Node2D = get_parent().get_parent()
	
	# Ensure that at least one instance is loaded
	var times_to_load: int = max(cast_amount, 1)
	
	# Cast spells with delay so player can actually visually see the spells being cast
	for i in range(times_to_load):
		var sceneNode: Node = scene.instantiate()
		if $"../RealmShift".is_in_shadowrealm:
			sceneNode.set_damage($"../RealmShift".shadow_strength)
		else:
			sceneNode.set_damage($"../RealmShift".light_strength)
			
		apply_modifications(sceneNode)
		
		player_sibling_container.add_child(sceneNode)
		
		timer.start()
		await timer.timeout
		
	# Reset cast_amount to 1
	cast_amount = 1
	
	# Clear spell modifications after casting
	reset_spell_modifications()
	
	casting = false  # Reset casting flag after casting is complete

func apply_modifications(sceneNode: Node) -> void:
	for key: String in spell_modifications.keys():
		match key:
			"DAMAGE_INCREASE":
				if sceneNode.has_method("set_damage"):
					var multiplier: float = spell_modifications[key]
					sceneNode.set_damage(multiplier)
			"SIZE_INCREASE":
				if sceneNode.has_method("set_size"):
					sceneNode.set_size(sceneNode.get("size") * spell_modifications[key])
			"ROOT_SCALE":
				if sceneNode.has_method("set_scale"):
					sceneNode.set_scale(sceneNode.get_scale() * spell_modifications[key])

func handle_sub1_type(data: ItemData) -> void:
	var sub_spell_type_name: String = ""
	match data.sub_spell_type:
		ItemData.SubSpellType.DAMAGE_INCREASE:
			sub_spell_type_name = "DAMAGE_INCREASE"
			if can_apply_self_damage(attack_up_self_damage):
				increase_damage_dealt()
		ItemData.SubSpellType.SIZE_INCREASE:
			sub_spell_type_name = "SIZE_INCREASE"
			if can_apply_self_damage(size_increase_self_damage):
				increase_spell_size()
		ItemData.SubSpellType.SPELL_DUPLICATION:
			sub_spell_type_name = "SPELL_DUPLICATION"
			if can_apply_self_damage(spell_dupe_self_damage):
				handle_spell_duplication()
		ItemData.SubSpellType.NONE:
			sub_spell_type_name = "NONE"
			
	if sub_spell_type_name != "NONE":
		print("AND THE AMAZING SUBSPELLTYPE IS %s" % sub_spell_type_name)
	else:
		print("SubSpellType is NONE or not set")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spell_slot1"):
		print_hotbar($"../PlayerSpells/Spells/MainSpellSlot", $"../PlayerSpells/Spells/SubSpellSlots", "Hotbar 1")
	elif event.is_action_pressed("spell_slot2"):
		print_hotbar($"../PlayerSpells/Spells/MainSpellSlot2", $"../PlayerSpells/Spells/SubSpellSlots2", "Hotbar 2")

func print_hotbar(main_spell_slot: Node, sub_spell_slot: Node, hotbar_name: String) -> void:
	# Check if there is a main spell, otherwise just don't execute it
	if !has_valid_panel_container(main_spell_slot):
		#print("Error: One or both PanelContainers have no children. Aborting function.")
		return
		
	if casting:
		return
		
	process_hotbar(sub_spell_slot, "Sub Slot", hotbar_name, false)
	process_hotbar(main_spell_slot, "Main Slot", hotbar_name, true)

func has_valid_panel_container(slot: Node) -> bool:
	for child in slot.get_children():
		if child is PanelContainer:
			return child.get_child_count() > 0
	return false

func process_hotbar(slot: Node, slot_type: String, hotbar_name: String, load_main_spell: bool) -> void:
	var children: Array = slot.get_children()
	var filtered_children: Array = []
	
	# Filter out PanelContainer elements
	for child:Node in children:
		if child is PanelContainer:
			filtered_children.append(child)
			
	# Process filtered children to find InventoryItem
	for child: Node in filtered_children:
		if child.get_child_count() > 0:
			var sub_child: Node = child.get_child(0)
			if sub_child is InventoryItem:
				var data: ItemData = sub_child.data
				if data:
					# Check if data type is SUB1 and handle it
					if data.type == ItemData.Type.SUB1:
						handle_sub1_type(data)
					elif load_main_spell:
						# Damage the player based on main spell, all do the same damage right now
						increase_self_damage(main_spell_self_damage)
						# Load the ability if not SUB1 and if loading main spell
						load_ability(data.name.to_lower())

func handle_spell_duplication() -> void:
	if can_apply_self_damage(spell_dupe_self_damage):
		cast_amount *= 2
		increase_self_damage(spell_dupe_self_damage)

func increase_damage_dealt() -> void:
	if can_apply_self_damage(attack_up_self_damage):
		if $"../RealmShift".is_in_shadowrealm:
			damage_up = 2.0 * $"../RealmShift".shadow_strength
		else:
			damage_up = 2.0 * $"../RealmShift".light_strength
			
		if not spell_modifications.has("DAMAGE_INCREASE"):
			spell_modifications["DAMAGE_INCREASE"] = damage_up # Initial modification value
		else:
			spell_modifications["DAMAGE_INCREASE"] *= damage_up  # Double the modification value
			
		increase_self_damage(attack_up_self_damage)

func increase_spell_size() -> void:
	if can_apply_self_damage(size_increase_self_damage):
		if not spell_modifications.has("ROOT_SCALE"):
			spell_modifications["ROOT_SCALE"] = Vector2(2, 2)  # Initial scale modification value
		else:
			spell_modifications["ROOT_SCALE"] *= 2.0  # Double the scale modification value
			
		increase_self_damage(size_increase_self_damage)

func can_apply_self_damage(self_damage: int) -> bool:
	return $"../HealthComponent".can_cast_spell(self_damage)

func increase_self_damage(self_damage: int) -> void:
	final_self_damage += self_damage

func reset_spell_modifications() -> void:
	spell_modifications.clear()
	final_self_damage = 0
	cast_amount = 1
