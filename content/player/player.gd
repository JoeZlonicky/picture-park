extends CharacterBody2D


@export_range(0.0, 200, 0.1, "suffix:px/s²", "or_greater") var acceleration: float = 100.0
@export_range(0.0, 200, 0.1, "suffix:px/s") var max_move_speed: float = 100.0

@onready var penguin_sprite: PenguinSprite = $PenguinSprite


func _process(_delta: float) -> void:
	var input := _get_input()
	penguin_sprite.look_direction = input


func _physics_process(delta: float) -> void:
	var input := _get_input()
	velocity = velocity.move_toward(input * max_move_speed, delta * acceleration)
	move_and_slide()


func _get_input() -> Vector2:
	return  Input.get_vector("move_left", "move_right", "move_up", "move_down")
