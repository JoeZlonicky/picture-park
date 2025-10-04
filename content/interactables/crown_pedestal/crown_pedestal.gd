class_name CrownPedestal
extends Node2D


const CROWN_HAT_SCENE := preload("uid://cswdnne5q4m53")

var unlocked: bool = false
var crown_on_pedestal: bool = true

@onready var crown: Sprite2D = $Crown
@onready var label: Label = $InteractableArea/Label


func _ready() -> void:
	update_progress(0, 1)


func update_progress(current: int, total: int) -> void:
	if current < total:
		label.text = str(current) + " / " + str(total)
		label.modulate = Color("e83b3b")
		unlocked = false
	else:
		label.modulate = Color.WHITE
		label.text = "Pick up [E]"
		unlocked = true


func _on_interactable_area_interacted_with() -> void:
	if unlocked and crown_on_pedestal:
		crown_on_pedestal = false
		crown.hide()
		var player := GameUtility.get_player()
		var crown_hat := CROWN_HAT_SCENE.instantiate() as Node2D
		player.equip_hat(crown_hat)
