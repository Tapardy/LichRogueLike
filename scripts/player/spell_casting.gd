extends Node2D

func load_ability(name):
	var scene = load("res://scenes/abilities/" + name + "/" + name + ".tscn")
	var sceneNode = scene.instance()
	add_child(sceneNode)
	return sceneNode
