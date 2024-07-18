extends Node2D

var is_in_shadowrealm = false
var tile_map_light: TileMap
var tile_map_dark: TileMap

func set_tile_maps(light: TileMap, dark: TileMap):
	tile_map_light = light
	tile_map_dark = dark
	print(light, dark)
	

func handle_realm_shift() -> void:
	is_in_shadowrealm = !is_in_shadowrealm
		
	if is_in_shadowrealm:
		tile_map_light.visible = false
		tile_map_dark.visible = true
		tile_map_light.tile_set.set_physics_layer_collision_layer(0,2)
		tile_map_dark.tile_set.set_physics_layer_collision_layer(0,1)
	else:
		tile_map_light.visible = true
		tile_map_dark.visible = false
		tile_map_light.tile_set.set_physics_layer_collision_layer(0,1)
		tile_map_dark.tile_set.set_physics_layer_collision_layer(0,2)
		
