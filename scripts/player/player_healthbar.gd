extends CanvasLayer

@onready var life_force: Node2D = $"../LifeForce"
@onready var life_force_container: ProgressBar = $LifeForceContainer
@onready var healthbar: ProgressBar = $Healthbar

var remaining_life_force: float = 10
var remaining_health: float = 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_shader_fill(life_force.max_life_force / 100)
	life_force.connect("life_force_changed", self.update_life_force)
	$"../HealthComponent".connect("health_changed", self.update_health)
	
func update_life_force() -> void:
	remaining_life_force = life_force.current_life_force
	update_shader_fill(remaining_life_force / 100)

func update_health()-> void:
	remaining_health = $"../HealthComponent".health
	update_health_shader(remaining_health / 100)
	
	
func update_shader_fill(value: float) -> void:
	var shader_material := life_force_container.material
	if shader_material is ShaderMaterial:
		shader_material.set_shader_parameter("fill_per", value)
		print(shader_material.get_shader_parameter("fill_per"))

func update_health_shader(value: float) -> void:
	var shader_material:= healthbar.material
	if shader_material is ShaderMaterial:
		shader_material.set_shader_parameter("percentage", value)
		
