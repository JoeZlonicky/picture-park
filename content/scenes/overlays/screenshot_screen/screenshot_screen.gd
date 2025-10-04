class_name ScreenshotScreen
extends CanvasLayer


signal closed

@onready var screenshot: TextureRect = %Screenshot


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("camera") and visible:
		hide()
		get_viewport().set_input_as_handled()
		closed.emit()


func show_screenshot(image: Image) -> void:
	screenshot.texture = ImageTexture.create_from_image(image)
