class_name DevDropdown
extends Button


const MENU_BUTTON_SCENE := preload("uid://8jjlwihhjf2h")
const SPACER_SCENE := preload("uid://8i28qv4armco")

@onready var menu: BoxContainer = $Menu


# Put menu population into this function so it will only be called in debug builds
func setup() -> void:
	pass


func add_to_menu(button_text: String, function: Callable) -> Button:
	var new_button: Button = MENU_BUTTON_SCENE.instantiate()
	new_button.text = button_text
	new_button.pressed.connect(function)
	menu.add_child(new_button)
	return new_button


func add_spacer() -> Control:
	var new_spacer: Control = SPACER_SCENE.instantiate()
	menu.add_child(new_spacer)
	return new_spacer


func _on_toggled(is_button_pressed: bool) -> void:
	menu.visible = is_button_pressed
	menu.global_position.x = global_position.x
	menu.global_position.y = global_position.y + get_rect().size.y
