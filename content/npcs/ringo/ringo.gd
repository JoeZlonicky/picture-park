class_name Ringo
extends StaticBody2D


var interacted_with: bool = false
var quest_complete: bool = false

@export var quest_requirement: Array[PhotoData] = []
@export var reward_scene: PackedScene

@onready var npc_trigger: NPCTrigger = $NPCTrigger
@onready var marker_2d: Marker2D = $Marker2D


func _ready() -> void:
	npc_trigger.show_question()


func _on_npc_trigger_interacted_with() -> void:
	if GameUtility.is_beat():
		_victory_dialogue()
	elif not interacted_with:
		_intro_dialogue()
	elif _is_requirement_met():
		_complete_dialogue()
		quest_complete = true
		npc_trigger.show_no_mark()
	elif not quest_complete:
		_incomplete_dialogue()
	else:
		_normal_dialogue()


func _intro_dialogue() -> void:
	NarrativeUtility.queue_dialogue(["How did you spot me?"], "???")
	NarrativeUtility.queue_dialogue(["Sorry, let me introduce myself. The name's Ringo.",
		"I've fascinated by these flowers, so I dyed my white feathers red to blend in!",
		"You must have amazing eyesight to see through my disguise.",
		"Or my disguise isn't as good as I thought...",
		"Either way, I would love to see a complete collection of all the plant life in the park!",
		"Let me know if you get photos of them all!"], "Ringo")
	interacted_with = true


func _incomplete_dialogue() -> void:
	NarrativeUtility.queue_dialogue(["I would love to see a complete collection of all the plant life in the park!"], "Ringo")


func _normal_dialogue() -> void:
	NarrativeUtility.queue_dialogue(["Good luck with the contest!"], "Ringo")


func _complete_dialogue() -> void:
	await NarrativeUtility.queue_dialogue(["Hey you have photos of all the plants!",
		"What fascinating biodiversity!",
		"Thanks for doing that! Here, you can take a photo of this for the contest.",
		"I've spent all day collecting it from the flowers here."],
		"Ringo")
	_on_quest_complete()


func _victory_dialogue() -> void:
	NarrativeUtility.queue_dialogue(["Congrats on winning the contest!"], "Ringo")


func _is_requirement_met() -> bool:
	for req in quest_requirement:
		if req and not GameUtility.get_game().photo_collection.has_photo(req):
			return false
	return true


func _on_quest_complete() -> void:
	if not reward_scene:
		return
	
	var reward = reward_scene.instantiate() as Node2D
	GameUtility.spawn(reward, marker_2d.global_position)
