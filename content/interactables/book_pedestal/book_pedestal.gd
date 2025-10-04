extends Node2D


signal opened


func _on_interactable_area_interacted_with() -> void:
	opened.emit()
