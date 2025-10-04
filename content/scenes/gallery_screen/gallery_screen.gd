class_name GallaryScreen
extends CanvasLayer


signal view_request(photo: Photo, title: String)

const PHOTO_BUTTON_SCENE := preload("uid://celgv7fhap4k5")

@onready var grid_container: GridContainer = %GridContainer


signal closed

func populate(all_photos: Array[PhotoData], collection: PhotoCollection) -> void:
	var current_buttons := grid_container.get_children()
	for button in current_buttons:
		button.queue_free()
	
	for data in all_photos:
		var button := PHOTO_BUTTON_SCENE.instantiate() as Button
		if collection.has_photo(data):
			button.text = data.name
			var photo := collection.get_photo(data)
			button.pressed.connect(_on_photo_button_pressed.bind(photo, data.name))
		else:
			button.text = "???"
			button.disabled = true
		grid_container.add_child(button)


func _on_photo_button_pressed(photo: Photo, title: String) -> void:
	view_request.emit(photo, title)


func _on_go_back_button_pressed() -> void:
	hide()
	closed.emit()
