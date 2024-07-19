extends Node2D

var is_in_shadowrealm: bool = false
var tile_map_light: TileMap
var tile_map_dark: TileMap
var player: CharacterBody2D
var tile_map: TileMap
var is_in_light: bool = false

func _ready() -> void:
	player = get_parent()
	print(player)
	
func set_tile_maps(light: TileMap, dark: TileMap) -> void:
	tile_map_light = light
	tile_map_dark = dark
	print(light, dark)

func handle_realm_shift() -> void:
	if can_shift_realm() and not is_in_light:
		is_in_shadowrealm = !is_in_shadowrealm
		update_tilemaps()

func change_realm(value: bool) -> void:
	print(value)
	is_in_shadowrealm = value
	is_in_light = true
	update_tilemaps()
	
func exit_light() -> void:
	is_in_light = false

func update_tilemaps() -> void:
	if is_in_shadowrealm:
		tile_map_light.visible = false
		tile_map_dark.visible = true
		tile_map_light.tile_set.set_physics_layer_collision_layer(0, 2)
		tile_map_dark.tile_set.set_physics_layer_collision_layer(0, 1)
	else:
		tile_map_light.visible = true
		tile_map_dark.visible = false
		tile_map_light.tile_set.set_physics_layer_collision_layer(0, 1)
		tile_map_dark.tile_set.set_physics_layer_collision_layer(0, 2)

func can_shift_realm() -> bool:
	if is_in_shadowrealm:
		tile_map = tile_map_light
	elif not is_in_shadowrealm:
		tile_map = tile_map_dark
		
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
