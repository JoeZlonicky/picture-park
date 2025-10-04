class_name GallaryScreen
extends CanvasLayer


signal view_request(photo: Photo, title: String)

const PHOTO_BUTTON_SCENE := preload("uid://celgv7fhap4k5")

@onready var grid_container: GridContainer = %GridContainer
@onready var go_back_button: Button = %GoBackButton


signal closed


func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		_on_go_back_button_pressed()
		get_viewport().set_input_as_handled()


func populate(all_photos: Array[PhotoData], collection: PhotoCollection) -> void:
	var current_buttons := grid_container.get_children()
	for button in current_buttons:
		button.queue_free()
	
	var focus_given: bool = false
	
	for data in all_photos:
		var button := PHOTO_BUTTON_SCENE.instantiate() as Button
		grid_container.add_child(button)
		
		if collection.has_photo(data):
			button.text = data.name
			var photo := collection.get_photo(data)
			button.pressed.connect(_on_photo_button_pressed.bind(photo, data.name))
			if not focus_given:
				focus_given = true
				button.grab_focus()
		else:
			button.text = "???"
			button.disabled = true
	
	if not focus_given:
		go_back_button.grab_focus()


func _on_photo_button_pressed(photo: Photo, title: String) -> void:
	view_request.emit(photo, title)


func _on_go_back_button_pressed() -> void:
	hide()
	closed.emit()
