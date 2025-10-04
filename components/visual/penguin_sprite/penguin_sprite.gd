class_name PenguinSprite
extends Sprite2D


@export var look_direction: Vector2

@export_range(0, 256, 0.1, "suffix:px/s") var look_speed: float = 64.0
@export_range(0, 64, 0.1) var eye_radius: float  = 0.0

@onready var left_eye: Sprite2D = %LeftEye
@onready var right_eye: Sprite2D = %RightEye


func _process(delta: float) -> void:
	var target := look_direction.limit_length(1.0) * eye_radius
	left_eye.position = left_eye.position.move_toward(target, look_speed * delta)
	right_eye.position = right_eye.position.move_toward(target, look_speed * delta)
