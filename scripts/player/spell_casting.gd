extends Node2D

# Function to load ability scenes
func load_ability(name: String) -> Node:
	var scene: = load("res://scenes/abilities/" + name + "/" + name + ".tscn")
	var sceneNode = scene.instance()
	add_child(sceneNode)
	return sceneNode

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spell_slot1"):
		print_hotbar($"../GUI/Spells/MainSpellSlot", $"../GUI/Spells/SubSpellSlots", "Hotbar 1")
	elif event.is_action_pressed("spell_slot2"):
		print_hotbar($"../GUI/Spells/MainSpellSlot2", $"../GUI/Spells/SubSpellSlots2", "Hotbar 2")

func print_hotbar(main_spell_slot: Node, sub_spell_slot: Node, hotbar_name: String) -> void:
	print("%s Contents:" % hotbar_name)
	process_and_print_hotbar(main_spell_slot, "Main Slot", hotbar_name)
	process_and_print_hotbar(sub_spell_slot, "Sub Slot", hotbar_name)

func process_and_print_hotbar(slot: Node, slot_type: String, hotbar_name: String) -> void:
	var children = slot.get_children()
	var filtered_children: Array = []

	# Filter out Sprite2D elements
	for child in children:
		if !(child is Sprite2D):
			filtered_children.append(child)

	# Process filtered children to find InventoryItem
	for child in filtered_children:
		if child.get_child_count() > 0:
			var sub_child = child.get_child(0)
			if sub_child is InventoryItem:
				var data = sub_child.data
				if data:
					# Print InventoryItem data
					print("%s %s ItemData:" % [hotbar_name, slot_type])
					print("Name: %s" % data.name)
					print("Description: %s" % data.description)
					print("Texture: %s" % data.texture)
				else:
					print("%s %s Child data is null" % [hotbar_name, slot_type])
			else:
				print("%s %s Child is not an InventoryItem" % [hotbar_name, slot_type])
		else:
			print("%s %s Slot has no children" % [hotbar_name, slot_type])
