extends Node2D

var cast_amount: int = 1
var timer: Timer
var casting: bool = false  # Add this flag to track casting state

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not timer:
		timer = Timer.new()
		timer.wait_time = 0.1  # Set the wait time to 0.1 seconds
		timer.one_shot = true
		add_child(timer)  # Add the Timer to the scene tree

# Function to load ability scenes multiple times based on cast_amount
func load_ability(name: String) -> void:
	if casting:
		print("Already casting. Please wait until casting is finished.")
		return
	
	casting = true  # Set casting flag to true
	print("cast_amount variable: ", cast_amount)
	var scene: PackedScene = load("res://scenes/abilities/" + name + "/" + name + ".tscn")
	
	# Get the player's parent node (which is the root node or any sibling container)
	var player_sibling_container = get_parent().get_parent()
	
	# Ensure that at least one instance is loaded
	var times_to_load = max(cast_amount, 1)
	
	# Cast spells with delay so player can actually visually see the spells being cast
	for i in range(times_to_load):
		# Instantiate and add the scene node
		var sceneNode: Node = scene.instantiate()
		player_sibling_container.add_child(sceneNode)
		
		# Wait for the specified duration
		timer.start()
		await timer.timeout  # Pause execution until the Timer times out
	
	# Reset cast_amount to 1
	cast_amount = 1
	
	casting = false  # Reset casting flag after casting is complete

# Function to handle SUB1 type data and print SubSpellType
func handle_sub1_type(data: ItemData) -> void:
	var sub_spell_type_name: String = ""
	match data.sub_spell_type:
		ItemData.SubSpellType.DAMAGE_INCREASE:
			sub_spell_type_name = "DAMAGE_INCREASE"
		ItemData.SubSpellType.SIZE_INCREASE:
			sub_spell_type_name = "SIZE_INCREASE"
		ItemData.SubSpellType.SPELL_DUPLICATION:
			sub_spell_type_name = "SPELL_DUPLICATION"
			handle_spell_duplication()
		ItemData.SubSpellType.NONE:
			sub_spell_type_name = "NONE"

	if sub_spell_type_name != "NONE":
		print("AND THE AMAZING SUBSPELLTYPE IS %s" % sub_spell_type_name)
	else:
		print("SubSpellType is NONE or not set")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spell_slot1"):
		print_hotbar($"../GUI/Spells/MainSpellSlot", $"../GUI/Spells/SubSpellSlots", "Hotbar 1")
	elif event.is_action_pressed("spell_slot2"):
		print_hotbar($"../GUI/Spells/MainSpellSlot2", $"../GUI/Spells/SubSpellSlots2", "Hotbar 2")

func print_hotbar(main_spell_slot: Node, sub_spell_slot: Node, hotbar_name: String) -> void:
	print("%s Contents:" % hotbar_name)
	
	# Check if there is a main spell, otherwise just don't execute it
	if !has_valid_panel_container(main_spell_slot):
		print("Error: One or both PanelContainers have no children. Aborting function.")
		return
	
	print(main_spell_slot.get_child_count())
	
	# Process and print sub spells
	print("Processing Sub Slot...")
	process_and_print_hotbar(sub_spell_slot, "Sub Slot", hotbar_name, false)
	
	# Load and print the main spell
	print("Processing Main Slot...")
	process_and_print_hotbar(main_spell_slot, "Main Slot", hotbar_name, true) 

func has_valid_panel_container(slot: Node) -> bool:
	for child in slot.get_children():
		if child is PanelContainer:
			return child.get_child_count() > 0
	return false

func process_and_print_hotbar(slot: Node, slot_type: String, hotbar_name: String, load_main_spell: bool) -> void:
	var children: Array = slot.get_children()
	var filtered_children: Array = []
	
	# Filter out PanelContainer elements
	for child in children:
		if child is PanelContainer:
			filtered_children.append(child)
	
	# Process filtered children to find InventoryItem
	for child in filtered_children:
		if child.get_child_count() > 0:
			var sub_child: Node = child.get_child(0)
			if sub_child is InventoryItem:
				var data: ItemData = sub_child.data
				if data:
					# Print InventoryItem data
					print("%s %s ItemData:" % [hotbar_name, slot_type])
					print("Name: %s" % data.name.to_lower())
					print("Description: %s" % data.description)
					print("Texture: %s" % data.texture)
					
					# Check if data type is SUB1 and handle it
					if data.type == ItemData.Type.SUB1:
						handle_sub1_type(data)
					elif load_main_spell:
						# Load the ability if not SUB1 and if loading main spell
						load_ability(data.name.to_lower())
				else:
					print("%s %s Child data is null" % [hotbar_name, slot_type])
			else:
				print("%s %s Child is not an InventoryItem" % [hotbar_name, slot_type])
		else:
			print("%s %s Slot has no children" % [hotbar_name, slot_type])

func handle_spell_duplication():
	cast_amount *= 2
