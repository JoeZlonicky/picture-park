class_name Edward
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
	NarrativeUtility.queue_dialogue(["Why hello there!"], "???")
	NarrativeUtility.queue_dialogue(["My name is Edward. It's a pleasure to meet you.",
		"I haven't seen Lil Flipper in a while and I'm worried about him.",
		"Can you let me know if you get a photo of him? I just want to make sure he is doing okay."], "Edward")
	interacted_with = true


func _incomplete_dialogue() -> void:
	NarrativeUtility.queue_dialogue(["Is Lil Flipper doing okay?"], "Edward")


func _normal_dialogue() -> void:
	NarrativeUtility.queue_dialogue(["Thanks again for the photo!"], "Edward")


func _complete_dialogue() -> void:
	await NarrativeUtility.queue_dialogue(["Hey you got a photo of Lil Flipper!",
	"Thank's for doing that, I'm glad he is doing okay.",
	"Oh hey I'll let you take a photo of this for the contest!"],
		"Edward")
	_on_quest_complete()


func _victory_dialogue() -> void:
	NarrativeUtility.queue_dialogue(["Congratulations on winning the contest!"], "Edward")


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
