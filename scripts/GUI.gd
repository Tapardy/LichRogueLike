extends CanvasLayer
class_name InventoryManager

var InvSize: int = 24
@export var itemsLoad: Array = [
	"res://Inventory/Items(Resources)/firebolt.tres",
	"res://Inventory/Items(Resources)/rock.tres",
	"res://Inventory/Items(Resources)/ground_stone.tres"
]
@export var itemsLoadSub: Array = [
	"res://Inventory/Items(Resources)/damage_increase.tres",
	"res://Inventory/Items(Resources)/damage_increase.tres",
	"res://Inventory/Items(Resources)/damage_increase.tres",
	
	"res://Inventory/Items(Resources)/spell_duplication.tres",
	"res://Inventory/Items(Resources)/spell_duplication.tres",
	"res://Inventory/Items(Resources)/spell_duplication.tres",
	
	"res://Inventory/Items(Resources)/size_increase.tres",
	"res://Inventory/Items(Resources)/size_increase.tres",
	"res://Inventory/Items(Resources)/size_increase.tres"
]

var main_slot_texture: Texture = preload("res://assets/invslot.png")
var sub_slot_texture: Texture = preload("res://assets/invslot.png")

func _ready() -> void:
	# Initialize primary inventory
	for i in range(InvSize):
		var slot := InventorySlot.new()
		var is_special := (i == InvSize - 1)  # Set the last slot as special
		slot.init(ItemData.Type.MAIN, Vector2(64, 64), main_slot_texture, is_special)
		$Inv.add_child(slot)

	for i in range(itemsLoad.size()):
		var item := InventoryItem.new()
		item.init(load(itemsLoad[i]))
		$Inv.get_child(i).add_child(item)

	# Initialize secondary inventory
	for i in range(InvSize):
		var slot := InventorySlot.new()
		var is_special := (i == InvSize - 1)  # Set the last slot as special
		slot.init(ItemData.Type.SUB1, Vector2(64, 64), sub_slot_texture, is_special)
		$InvSub.add_child(slot)

	for i in range(itemsLoadSub.size()):
		var item := InventoryItem.new()
		item.init(load(itemsLoadSub[i]))
		$InvSub.get_child(i).add_child(item)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_inventory"):
		print("triggered inventory")
		self.visible = !self.visible

# Public function to add an item to the main inventory
func add_item_to_main(item_path: String) -> void:
	if itemsLoad.size() < InvSize - 1:
		itemsLoad.append(item_path)
		update_inventory()

# Public function to add an item to the secondary inventory
func add_item_to_sub(item_path: String) -> void:
	if itemsLoadSub.size() < InvSize - 1:
		itemsLoadSub.append(item_path)
		update_inventory()

# Check if an item can be added to the main inventory
func can_add_item_to_main(item_path: String) -> bool:
	return itemsLoad.size() < InvSize - 1

# Check if an item can be added to the secondary inventory
func can_add_item_to_sub(item_path: String) -> bool:
	return itemsLoadSub.size() < InvSize - 1

# Public function to remove an item from the inventory
func remove_item(item: InventoryItem) -> void:
	var item_path := item.data.resource_path
	itemsLoad.erase(item_path)
	itemsLoadSub.erase(item_path)
	update_inventory()

# Update inventory display
func update_inventory() -> void:
	# Clear existing items in primary inventory slots
	for slot in $Inv.get_children():
		for child in slot.get_children():
			if child is InventoryItem:
				child.queue_free()
				
	# Add new items to primary inventory
	for i in range(itemsLoad.size()):
		if i < $Inv.get_child_count():
			var slot := $Inv.get_child(i) as InventorySlot
			var item := InventoryItem.new()
			item.init(load(itemsLoad[i]))
			slot.add_child(item)
			
	# Clear existing items in secondary inventory slots
	for slot in $InvSub.get_children():
		for child in slot.get_children():
			if child is InventoryItem:
				child.queue_free()
				
	# Add new items to secondary inventory
	for i in range(itemsLoadSub.size()):
		if i < $InvSub.get_child_count():
			var slot := $InvSub.get_child(i) as InventorySlot
			var item := InventoryItem.new()
			item.init(load(itemsLoadSub[i]))
			slot.add_child(item)
