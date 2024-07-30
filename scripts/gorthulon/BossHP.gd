extends CanvasLayer

@onready var healthbar: ProgressBar = $Healthbar


var remaining_life_force: float = 10
var remaining_health: float = 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../HealthComponent".connect("health_changed", self.update_health)

func update_health()-> void:
	remaining_health = $"../HealthComponent".health
	update_health_shader(remaining_health / 750)
	
func update_health_shader(value: float) -> void:
	var shader_material:= healthbar.material
	if shader_material is ShaderMaterial:
		shader_material.set_shader_parameter("percentage", value)
		
