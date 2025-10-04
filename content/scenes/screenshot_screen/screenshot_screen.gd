class_name ScreenshotScreen
extends CanvasLayer


signal closed

var is_temp: bool = false
var current_photo: Photo = null

@onready var title_label: Label = %TitleLabel
@onready var new_label: Label = %NewLabel
@onready var updated_label: Label = %UpdatedLabel
@onready var screenshot: TextureRect = %Screenshot
@onready var save_button: Button = %SaveButton
@onready var continue_button: Button = %ContinueButton
@onready var coord_label: Label = %CoordLabel


func _ready() -> void:
	if OS.get_name() == "Web":
		save_button.disabled = true


func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		_on_continue_button_pressed()
		get_viewport().set_input_as_handled()


func show_new_screenshot(photo: Photo, changes: Dictionary[PhotoData, bool]) -> void:
	screenshot.texture = ImageTexture.create_from_image(photo.image)
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
	coord_label.text = photo.get_taken_at_string()
	is_temp = false
	save_button.show()
	continue_button.grab_focus()
	current_photo = photo


func show_owned_screenshot(photo: Photo, title: String) -> void:
	screenshot.texture = ImageTexture.create_from_image(photo.image)
	coord_label.text = photo.get_taken_at_string()
	new_label.hide()
	updated_label.hide()
	title_label.text = title
	is_temp = true
	save_button.show()
	continue_button.grab_focus()
	current_photo = photo


func _on_continue_button_pressed() -> void:
	hide()
	get_viewport().set_input_as_handled()
	closed.emit()


func _on_save_button_pressed() -> void:
	if current_photo:
		var file_path := "user://" + str(current_photo.time_taken) + ".png"
		current_photo.image.save_png(file_path)
	save_button.hide()
	continue_button.grab_focus()
