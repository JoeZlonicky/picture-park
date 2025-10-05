class_name NPCTrigger
extends Node2D


signal interacted_with

@onready var question_label: Label = $VBoxContainer/QuestionLabel


func _ready() -> void:
	question_label.hide()


func _on_interactable_area_interacted_with() -> void:
	interacted_with.emit()


func show_question() -> void:
	question_label.text = "?"
	question_label.show()


func show_exclamation() -> void:
	question_label.text = "!"
	question_label.show()


func show_no_mark() -> void:
	question_label.text = ""
	question_label.hide()
