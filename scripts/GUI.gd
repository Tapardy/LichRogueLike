extends CanvasLayer

var InvSize: int = 9
var itemsLoad: Array = [
	"res://Inventory/Items(Resources)/firebolt.tres",
	"res://Inventory/Items(Resources)/rock.tres",
	"res://Inventory/Items(Resources)/ground_stone.tres"
]
var itemsLoadSub: Array = [
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
		slot.init(ItemData.Type.MAIN, Vector2(64, 64), main_slot_texture)
		$Inv.add_child(slot)

	for i in range(itemsLoad.size()):
		var item := InventoryItem.new()
		item.init(load(itemsLoad[i]))
		$Inv.get_child(i).add_child(item)

	# Initialize secondary inventory
	for i in range(InvSize):
		var slot := InventorySlot.new()
		slot.init(ItemData.Type.SUB1, Vector2(64, 64), sub_slot_texture)
		$InvSub.add_child(slot)

	for i in range(itemsLoadSub.size()):
		var item := InventoryItem.new()
		item.init(load(itemsLoadSub[i]))
		$InvSub.get_child(i).add_child(item)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_inventory"):
		print("triggered inventory")
		self.visible = !self.visible
