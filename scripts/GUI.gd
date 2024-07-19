extends CanvasLayer
var InvSize: int = 16
var itemsLoad: Array = [
	"res://Inventory/Items(Resources)/firebolt.tres"
]

func _ready() -> void:
	for i in InvSize:
		var slot := InventorySlot.new()
		slot.init(ItemData.Type.MAIN, Vector2(64,64))
		$Inv.add_child(slot)
		
	for i in itemsLoad.size():
		var item:= InventoryItem.new()
		item.init(load(itemsLoad[i]))
		$Inv.get_child(i).add_child(item)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_inventory"):
		print("triggered inventory")
		self.visible = !self.visible
