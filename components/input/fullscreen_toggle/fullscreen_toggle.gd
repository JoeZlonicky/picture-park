class_name FullscreenToggle
extends Node
## Toggles between windowed and fullscreen when input action is pressed

@export_custom(PROPERTY_HINT_INPUT_NAME, "") var input_name: StringName

func _input(event: InputEvent) -> void:
	if not event.is_action_pressed(input_name):
		return
	
	var is_fullscreen := DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
