class_name GameUtility


static func get_game() -> Game:
	var scene_tree := Engine.get_main_loop() as SceneTree
	var game := scene_tree.current_scene as Game
	assert(game, "Trying to get game at an invalid time")
	return game


static func get_player() -> Player:
	var game := get_game()
	return game.player
