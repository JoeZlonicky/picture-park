extends CanvasLayer


@export_custom(PROPERTY_HINT_INPUT_NAME, "") var toggle_action: StringName

@onready var dropdowns_container: BoxContainer = $Panel/MarginContainer/Dropdowns


func _ready() -> void:
	if !OS.is_debug_build():
		queue_free()
		return
	
	hide()
	
	for dropdown: DevDropdown in dropdowns_container.get_children():
		dropdown.setup()


func _input(event: InputEvent) -> void:
	if not toggle_action or not event.is_action_pressed(toggle_action):
		return
	
	visible = not visible
