extends Node2D


@onready var pause_menu: CanvasLayer = $PauseMenu


func _ready() -> void:
	get_tree().paused = true


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not pause_menu.visible:
		get_tree().paused = true
		pause_menu.show()
		get_viewport().set_input_as_handled()


func _on_main_menu_closed() -> void:
	get_tree().paused = false
