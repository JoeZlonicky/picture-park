extends Node2D

const CAMERA_TOOL_SCENE := preload("uid://canbxhucaf17u")

var camera_tool: CameraTool = null

@onready var screenshot_screen: ScreenshotScreen = $ScreenshotScreen
@onready var pause_menu: CanvasLayer = $PauseMenu
@onready var main_menu: CanvasLayer = $MainMenu

@onready var camera_place_marker: Marker2D = $World/Player/CameraPlaceMarker
@onready var world: Node2D = $World
@onready var camera_2d: Camera2D = $World/Player/Camera2D
@onready var ground: ColorRect = $Ground


func _ready() -> void:
	if main_menu.visible:
		get_tree().paused = true
	CameraUtilty.set_limits_from_rect(camera_2d, ground.get_global_rect())


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not pause_menu.visible:
		get_tree().paused = true
		pause_menu.show()
		get_viewport().set_input_as_handled()
	if event.is_action_pressed("camera"):
		if not camera_tool:
			_place_camera()
		elif screenshot_screen.visible:
			screenshot_screen.hide()
			get_viewport().set_input_as_handled()
			get_tree().paused = false


func _place_camera() -> void:
	camera_tool = CAMERA_TOOL_SCENE.instantiate()
	camera_tool.global_position = camera_place_marker.global_position
	camera_tool.photo_taken.connect(_on_camera_tool_photo_taken)
	world.add_child(camera_tool)
	
	camera_tool.set_limits(ground.get_global_rect())


func _on_main_menu_closed() -> void:
	get_tree().paused = false


func _on_camera_tool_photo_taken(image: Image) -> void:
	screenshot_screen.show_screenshot(image)
	screenshot_screen.show()
	get_tree().paused = true


func _on_screenshot_screen_closed() -> void:
	get_tree().paused = false
