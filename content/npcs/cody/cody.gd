class_name Cody
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
	NarrativeUtility.queue_dialogue(["Yo what's up bro!"], "???")
	NarrativeUtility.queue_dialogue(["My friends call me Cody.",
		"And you seem pretty chill, so Cody it is!",
		"Why don't you talk to me once you've taken photos of all the penguins in the park!",
		"I have a surprise for you!"], "Cody")
	interacted_with = true


func _incomplete_dialogue() -> void:
	NarrativeUtility.queue_dialogue(["Why don't you talk to me once you've taken photos of all the penguins in the park!"], "Cody")


func _normal_dialogue() -> void:
	NarrativeUtility.queue_dialogue(["You got this, bro!"], "Cody")


func _complete_dialogue() -> void:
	await NarrativeUtility.queue_dialogue(["Yo, you got photos of all the penguins!",
		"Look how sick we all look!",
		"Thanks for doing that bro. Here, you can take a photo of this for the contest!"],
		"Cody")
	_on_quest_complete()


func _victory_dialogue() -> void:
	NarrativeUtility.queue_dialogue(["Yo congrats on winning the contest! That's rad!"], "Cody")


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
