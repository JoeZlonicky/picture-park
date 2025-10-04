class_name TransitionScreen
extends CanvasLayer


@onready var _animation_player: AnimationPlayer = $AnimationPlayer


func fade_to_black() -> void:
	_animation_player.play("fade_to_black")
	await _animation_player.animation_finished


func fade_from_black() -> void:
	_animation_player.play("fade_from_black")
	await _animation_player.animation_finished
