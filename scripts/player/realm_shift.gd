extends Node2D

var is_in_shadowrealm: bool = false
var tile_map_light: TileMap
var tile_map_dark: TileMap
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
	print(player)
	
	# Ensure the ShadowStrengthTimer is properly set up
	$ShadowStrengthTimer.wait_time = 0.1  # Adjust this value as needed for your update frequency

func set_tile_maps(light: TileMap, dark: TileMap) -> void:
	tile_map_light = light
	tile_map_dark = dark
	update_tilemaps()

func handle_realm_shift() -> void:
	if can_shift and can_shift_realm():
		if is_in_light:
			$Label.text = "Can't switch realms in the light"
			return
		
		$"../Camera2D/AnimationPlayer".play("dissolve")
		$"../GUI".add_item_to_main("res://Inventory/Items(Resources)/ground_stone.tres")
		is_in_shadowrealm = !is_in_shadowrealm
		update_tilemaps()
		can_shift = false  # Start cooldown
		$Timer.start(0.75)  # Start the cooldown timer

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
		tile_map_dark.visible = true
		update_collision_layers(tile_map_light, tile_map_dark)
	else:
		tile_map_light.visible = true
		tile_map_dark.visible = false
		update_collision_layers(tile_map_dark, tile_map_light)

func update_collision_layers(active_map: TileMap, inactive_map: TileMap) -> void:
	active_map.tile_set.set_physics_layer_collision_layer(0, 1)
	inactive_map.tile_set.set_physics_layer_collision_layer(0, 2)

func can_shift_realm() -> bool:
	tile_map = tile_map_light if is_in_shadowrealm else tile_map_dark
	var target_tile: Vector2 = tile_map.local_to_map(player.global_position)
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	print(tile_data)
	if !tile_data:
		return true
	if tile_data.get_custom_data("solid") == true:
		$Timer.start()
		$Label.text = "Can't switch realms"
		return false
	else:
		return true

func _on_timer_timeout() -> void:
	$Label.text = ""
	can_shift = true  # Reset cooldown flag

func start_shadow_realm_strength_increase() -> void:
	shadow_strength = 1.0
	light_strength = 1.0
	$ShadowStrengthTimer.start()  # Start the strength adjustment timer

func start_light_realm_strength_decrease() -> void:
	$ShadowStrengthTimer.start()  # Start the strength adjustment timer

func _on_shadow_strength_timer_timeout() -> void:
	if is_in_shadowrealm:
		if shadow_strength < 1.5:
			shadow_strength += strength_increase_rate
		if light_strength > 0.5:
			light_strength -= strength_decrease_rate
	else:
		# Gradually reset shadow_strength
		if shadow_strength > 1.0:
			shadow_strength -= strength_decrease_rate
		# Gradually reset light_strength
		if light_strength < 1.0:
			light_strength += strength_decrease_rate
		if light_strength >= 1.0:
			$ShadowStrengthTimer.stop()  # Stop the timer when reaching the default strength
