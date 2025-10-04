class_name Photo
extends RefCounted


var image: Image
var taken_at: Vector2
var time_taken: float
var captures: Array[PhotoData]


func _init(p_image: Image, p_taken_at: Vector2, p_time_taken: float, p_captures: Array[PhotoData] = []):
	image = p_image
	taken_at = p_taken_at
	time_taken = p_time_taken
	captures = p_captures
