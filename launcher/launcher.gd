extends Node
## Intended to be run as the first scene of the project


@export var _default_main_scene: PackedScene
@export var _debug_main_scene: PackedScene
@export var _min_window_size: Vector2i
@export_color_no_alpha var _render_clear_color: Color = Color.BLACK


func _ready() -> void:
	_initial_config()
	_launch_start_scene()


func _initial_config() -> void:
	RenderingServer.set_default_clear_color(_render_clear_color)
	get_window().min_size = _min_window_size


func _launch_start_scene() -> void:
	if OS.is_debug_build() and _debug_main_scene:
		get_tree().change_scene_to_packed.call_deferred(_debug_main_scene)
		return
	
	assert(_default_main_scene, "Default main scene is not set")
	get_tree().change_scene_to_packed.call_deferred(_default_main_scene)
