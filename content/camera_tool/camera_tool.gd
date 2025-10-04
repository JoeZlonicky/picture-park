class_name CameraTool
extends StaticBody2D

signal photo_taken(image: Image)

@onready var marker_2d: Marker2D = $Marker2D
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport
@onready var preview_camera_2d: Camera2D = $SubViewportContainer/SubViewport/Camera2D
@onready var screenshot_camera_2d: Camera2D = $SubViewport/Camera2D
@onready var screenshot_viewport: SubViewport = $SubViewport
@onready var timer: Timer = $Timer
@onready var label: Label = $Label


func _ready() -> void:
	sub_viewport.world_2d = get_viewport().world_2d
	screenshot_viewport.world_2d = get_viewport().world_2d


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and timer.is_stopped():
		start_timer()
		get_viewport().set_input_as_handled()
	if event.is_action_pressed("camera"):
		queue_free()


func _process(_delta: float) -> void:
	if timer.is_stopped():
		label.hide()
		return
	
	label.text = str(roundi(timer.time_left))
	label.show()


func _physics_process(_delta: float) -> void:
	preview_camera_2d.global_position = marker_2d.global_position
	screenshot_camera_2d.global_position = marker_2d.global_position


func set_limits(rect: Rect2i) -> void:
	CameraUtilty.set_limits_from_rect(preview_camera_2d, rect)
	CameraUtilty.set_limits_from_rect(screenshot_camera_2d, rect)


func start_timer() -> void:
	timer.start()


func take_photo() -> void:
	label.hide()
	await RenderingServer.frame_post_draw
	var image := screenshot_viewport.get_texture().get_image()
	photo_taken.emit(image)


func _on_timer_timeout() -> void:
	take_photo()
