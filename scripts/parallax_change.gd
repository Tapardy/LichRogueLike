extends Area2D




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.position.x > 5473.924:
		body.change_parallax($"../TileMapLight/ParallaxForestLight", $"../TileMapDark/ParallaxForestDark")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player")and body.position.x > 5473.924:
		body.change_parallax($"../TileMapLight/ParallaxCaveLight", $"../TileMapDark/ParallaxCaveDark")
