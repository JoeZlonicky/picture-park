class_name Game
extends Node2D

const CAMERA_TOOL_SCENE := preload("uid://canbxhucaf17u")

@export var all_photos: Array[PhotoData]

var photo_collection := PhotoCollection.new()
var camera_tool: CameraTool = null
var placed_camera_before: bool = false

@onready var screenshot_screen: ScreenshotScreen = $ScreenshotScreen
@onready var gallery_screen: GallaryScreen = $GalleryScreen
@onready var pause_menu: CanvasLayer = $PauseMenu
@onready var main_menu: CanvasLayer = $MainMenu

@onready var player: Player = $World/Player
@onready var camera_place_marker: Marker2D = $World/Player/CameraPlaceMarker
@onready var world: Node2D = $World
@onready var camera_2d: Camera2D = $World/Player/Camera2D
@onready var ground: ColorRect = $Ground
@onready var crown_pedestal: CrownPedestal = $World/CrownPedestal

@onready var move_tutorial: Label = $IceRink/MoveTutorial
@onready var camera_tutorial: Label = $IceRink/CameraTutorial


func _ready() -> void:
	if main_menu.visible:
		get_tree().paused = true
	CameraUtilty.set_limits_from_rect(camera_2d, ground.get_global_rect())
	crown_pedestal.update_progress(photo_collection.get_all_captures().size(), all_photos.size())


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
	
	if not placed_camera_before:
		placed_camera_before = true
		var tween := create_tween()
		tween.tween_property(camera_tutorial, "modulate:a", 0.0, 1)


func _on_main_menu_closed() -> void:
	get_tree().paused = false


func _on_camera_tool_photo_taken(photo: Photo) -> void:
	var result := photo_collection.add_photo(photo)
	screenshot_screen.show_new_screenshot(photo.image, result)
	screenshot_screen.show()
	
	crown_pedestal.update_progress(photo_collection.get_all_captures().size(), all_photos.size())
	get_tree().paused = true


func _on_screenshot_screen_closed() -> void:
	if screenshot_screen.is_temp:
		gallery_screen.populate(all_photos, photo_collection)
		gallery_screen.show()
	else:
		get_tree().paused = false


func _on_book_pedestal_opened() -> void:
	get_tree().paused = true
	gallery_screen.populate(all_photos, photo_collection)
	gallery_screen.show()


func _on_gallery_screen_view_request(photo: Photo, title: String) -> void:
	gallery_screen.hide()
	screenshot_screen.show_owned_screenshot(photo.image, title)
	screenshot_screen.show()


func _on_gallery_screen_closed() -> void:
	get_tree().paused = false


func _on_player_moved_for_first_time() -> void:
	var tween := create_tween()
	tween.tween_property(move_tutorial, "modulate:a", 0.0, 1)
