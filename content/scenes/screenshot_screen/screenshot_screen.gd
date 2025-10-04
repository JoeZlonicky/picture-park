class_name ScreenshotScreen
extends CanvasLayer


signal closed

var is_temp: bool = false

@onready var title_label: Label = %TitleLabel
@onready var new_label: Label = %NewLabel
@onready var updated_label: Label = %UpdatedLabel
@onready var screenshot: TextureRect = %Screenshot


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("camera") and visible:
		hide()
		get_viewport().set_input_as_handled()
		closed.emit()


func show_new_screenshot(image: Image, changes: Dictionary[PhotoData, bool]) -> void:
	screenshot.texture = ImageTexture.create_from_image(image)
	var additions: Array[String] = []
	var updated: Array[String] = []
	for data in changes:
		if changes[data]:
			additions.append(data.name)
		else:
			updated.append(data.name)
	
	if additions:
		new_label.text = "First photo of: " + ", ".join(additions)
		new_label.show()
	else:
		new_label.hide()
	
	if updated:
		updated_label.text = "Updated: " + ", ".join(updated)
		updated_label.show()
	else:
		updated_label.hide() 
	
	title_label.text = "New Photo!"
	is_temp = false


func show_owned_screenshot(image: Image, title: String) -> void:
	screenshot.texture = ImageTexture.create_from_image(image)
	new_label.hide()
	updated_label.hide()
	title_label.text = title
	is_temp = true
