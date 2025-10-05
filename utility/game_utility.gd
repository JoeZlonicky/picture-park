class_name GameUtility


static func get_game() -> Game:
	var scene_tree := Engine.get_main_loop() as SceneTree
	var game := scene_tree.current_scene as Game
	assert(game, "Trying to get game at an invalid time")
	return game


static func get_player() -> Player:
	var game := get_game()
	return game.player


static func is_beat() -> bool:
	var game := get_game()
	return game.crown_pedestal.unlocked


static func spawn(node: Node2D, at: Vector2) -> void:
	var game := get_game()
	game.world.add_child(node)
	node.global_position = at
