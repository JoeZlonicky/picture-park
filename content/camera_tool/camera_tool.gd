class_name CameraTool
extends StaticBody2D

signal photo_taken(photo: Photo)

@onready var collection_area: Area2D = $Marker2D/CollectionArea
@onready var marker_2d: Marker2D = $Marker2D
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport
@onready var preview_camera_2d: Camera2D = $SubViewportContainer/SubViewport/Camera2D
@onready var screenshot_camera_2d: Camera2D = $SubViewport/Camera2D
@onready var screenshot_viewport: SubViewport = $SubViewport
@onready var timer: Timer = $Timer
@onready var label: Label = $Label
@onready var interactable_area: InteractableArea = $InteractableArea
@onready var interact_collision_shape_2d: CollisionShape2D = $InteractableArea/CollisionShape2D


func _ready() -> void:
	sub_viewport.world_2d = get_viewport().world_2d
	screenshot_viewport.world_2d = get_viewport().world_2d


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("camera") and interactable_area.is_prioritized():
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
	interact_collision_shape_2d.disabled = true


func take_photo() -> void:
	label.hide()
	await RenderingServer.frame_post_draw
	var captures: Array[PhotoData] = []
	for area in collection_area.get_overlapping_areas():
		if not area is PhotoNode:
			continue
		
		if not area.data:
			push_warning(area.owner.name + " has a PhotoNode without data!")
			continue
		if not area.data.name:
			push_warning(area.owner.name + " has a PhotoNode without a data.name!")
		if captures.has(area.data):
			continue
		
		captures.append(area.data)
	
	var image := screenshot_viewport.get_texture().get_image()
	var photo := Photo.new(image, marker_2d.global_position, Time.get_ticks_msec(), captures)
	photo_taken.emit(photo)
	interact_collision_shape_2d.disabled = false


func _on_timer_timeout() -> void:
	take_photo()


func _on_interactable_area_interacted_with() -> void:
	if timer.is_stopped():
		start_timer()
