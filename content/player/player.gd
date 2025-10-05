class_name Player
extends CharacterBody2D


signal moved_for_first_time

@export_range(0.0, 200, 0.1, "suffix:px/s²", "or_greater") var acceleration: float = 100.0
@export_range(0.0, 200, 0.1, "suffix:px/s", "or_greater") var max_move_speed: float = 100.0
@export_range(0.0, 30.0, 0.1, "suffix:°") var max_swing: float = 20.0
@export_range(0.0, 60.0, 0.1, "suffix:°/s") var swing_speed: float = 20.0

# -1, 0, or 1
var swing_direction: int = 0
var moved_before: bool = false
var hat: Node2D = null

@onready var penguin_sprite: PenguinSprite = $PenguinSprite
@onready var hat_slot: Marker2D = $PenguinSprite/HatSlot
@onready var packed_camera: Sprite2D = $PenguinSprite/PackedCamera
@onready var camera_strap: Sprite2D = $PenguinSprite/CameraStrap


func _process(delta: float) -> void:
	var input := _get_input()
	penguin_sprite.look_direction = input
	penguin_sprite.rotation_degrees = move_toward(penguin_sprite.rotation_degrees,
		max_swing * swing_direction, swing_speed * delta)
	if swing_direction > 0 and is_equal_approx(penguin_sprite.rotation_degrees, max_swing):
		swing_direction = -1
	elif swing_direction < 0 and is_equal_approx(penguin_sprite.rotation_degrees, -max_swing):
		swing_direction = 1


func _physics_process(delta: float) -> void:
	var input := _get_input()
	if input.x and swing_direction == 0:
		swing_direction = 1 if input.x > 0 else -1
	elif input.y and swing_direction == 0:
		swing_direction = 1 if randf() > 0.5 else -1
	elif input.is_zero_approx() and swing_direction:
		swing_direction = 0
	
	if input and not moved_before:
		moved_before = true
		moved_for_first_time.emit()
	
	velocity = velocity.move_toward(input * max_move_speed, delta * acceleration)
	move_and_slide()


func toggle_packed_camera(show_camera: bool) -> void:
	packed_camera.visible = show_camera
	camera_strap.visible = show_camera


func equip_hat(new_hat: Node2D) -> void:
	remove_hat()
	hat_slot.add_child(new_hat)
	hat = new_hat


func remove_hat() -> void:
	if hat:
		hat.queue_free()


func _get_input() -> Vector2:
	if GameUtility.get_game().pause_input_counter > 0:
		return Vector2.ZERO
	return  Input.get_vector("move_left", "move_right", "move_up", "move_down")
