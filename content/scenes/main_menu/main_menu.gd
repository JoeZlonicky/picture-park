extends CanvasLayer

signal closed


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("camera") and visible:
		hide()
		get_viewport().set_input_as_handled()
		closed.emit()
