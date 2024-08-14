extends Node2D

var is_in_shadowrealm: bool = false
var tile_map_light: TileMap
var tile_map_dark: TileMap
var parallax_light: ParallaxBackground
var parallax_dark: ParallaxBackground
var player: CharacterBody2D
var tile_map: TileMap
var can_shift: bool = true  # Variable to track cooldown

# Variables for strength multipliers
var shadow_strength: float = 1.0
var light_strength: float = 1.0
var strength_increase_rate: float = 0.1  # Rate at which strength increases
var strength_decrease_rate: float = 0.05  # Rate at which strength decreases
var strength_transition_time: float = 2.0  # Time to transition strength back to default

var is_in_light: bool = false  # Variable to track if the player is in the light

func _ready() -> void:
	player = get_parent()
	
	# Ensure the ShadowStrengthTimer is properly set up
	$ShadowStrengthTimer.wait_time = 0.1  # Adjust this value as needed for your update frequency
	$ShadowStrengthTimer.one_shot = true  # Ensure the timer only runs once per start
	$Timer.wait_time = 1  # Adjust this value as needed for your cooldown period
	$Timer.one_shot = true  # Ensure the timer only runs once per start

func set_tile_maps(light: TileMap, dark: TileMap, outer_parallax_light: ParallaxBackground, outer_parallax_dark: ParallaxBackground) -> void:
	tile_map_light = light
	tile_map_dark = dark
	parallax_light = outer_parallax_light
	parallax_dark = outer_parallax_dark

func set_parallax(new_parallax_light: ParallaxBackground, new_parallax_dark: ParallaxBackground) -> void:
	parallax_light.visible = false
	parallax_dark.visible = false
	parallax_light = new_parallax_light
	parallax_dark = new_parallax_dark
	update_tilemaps()
	
func handle_realm_shift() -> void:
	if can_shift and can_shift_realm():
		if is_in_light:
			$Label.text = "Can't switch realms in the light"
			$Timer.start()  # Start the cooldown timer
			return
		
		$"../Camera2D/AnimationPlayer".play("dissolve")
		is_in_shadowrealm = !is_in_shadowrealm
		update_tilemaps()
		can_shift = false  # Start cooldown
		$Timer.start()  # Start the cooldown timer

		if is_in_shadowrealm:
			start_shadow_realm_strength_increase()
		else:
			start_light_realm_strength_decrease()

func change_realm(value: bool) -> void:
	is_in_shadowrealm = value
	update_tilemaps()

	if is_in_shadowrealm:
		start_shadow_realm_strength_increase()
	else:
		start_light_realm_strength_decrease()

func update_tilemaps() -> void:
	if is_in_shadowrealm:
		tile_map_light.visible = false
		parallax_light.visible = false
		parallax_dark.visible = true
		tile_map_dark.visible = true
		tile_map_light.tile_set.set_physics_layer_collision_layer(0, 2)
		tile_map_dark.tile_set.set_physics_layer_collision_layer(0, 1)
	else:
		tile_map_light.visible = true
		parallax_light.visible = true
		parallax_dark.visible = false
		tile_map_dark.visible = false
		tile_map_light.set_physics_process(false)
		tile_map_light.set_process(false)
		tile_map_dark.set_physics_process(false)
		
		tile_map_light.tile_set.set_physics_layer_collision_layer(0, 1)
		tile_map_dark.tile_set.set_physics_layer_collision_layer(0, 2)

func can_shift_realm() -> bool:
	if is_in_shadowrealm:
		tile_map = tile_map_light
	else:
		tile_map = tile_map_dark
		
	var target_tile: Vector2 = tile_map.local_to_map(player.global_position)
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	if !tile_data:
		return true
	if tile_data.get_custom_data("solid") == true:
		$Timer.start()  # Start the cooldown timer for realm shift
		$Label.text = "Can't switch realms"
		return false
	else:
		return true
	
func _on_timer_timeout() -> void:
	$Label.text = ""
	can_shift = true  # Reset cooldown flag

# Function to start increasing shadow realm strength
func start_shadow_realm_strength_increase() -> void:
	shadow_strength = 1.0
	light_strength = 1.0
	#$ShadowStrengthTimer.start()  # Start the strength adjustment timer

# Function to start decreasing light realm strength
func start_light_realm_strength_decrease() -> void:
	#$ShadowStrengthTimer.start()  # Start the strength adjustment timer
	pass

func _on_shadow_strength_timer_timeout() -> void:
	pass
