extends StaticBody2D


var interacted_with: bool = false

@onready var npc_trigger: NPCTrigger = $NPCTrigger


func _ready() -> void:
	npc_trigger.show_question()


func _on_npc_trigger_interacted_with() -> void:
	if GameUtility.is_beat():
		_victory_dialogue()
	elif not interacted_with:
		_intro_dialogue()
	else:
		_normal_dialogue()


func _intro_dialogue() -> void:
	NarrativeUtility.queue_dialogue(["Hello there, newcomer!"], "???")
	NarrativeUtility.queue_dialogue(["Penguins call me Mr. Penguin.",
		"I'm not entirely sure why.",
		"But I think it fits me!",
		"Anyways, welcome to Picture Park! This lovely place is just cold enough for us penguins, but with scenery you just can't get in Antarctica!",
		"I see you brought your camera, which is perfect! Because I'm hosting a bit of a photo contest!",
		"To win the contest, and get this lovely gold crown, you have to fill up that photo album over there.",
		"But it can't just be the same photos, you need variety!",
		"I won't spoil what that all entails, but you can see your current collection of photos at anytime by checking the photo album!",
		"I wish you the best of luck!"], "Mr. Penguin")
	interacted_with = true
	npc_trigger.show_no_mark()


func _normal_dialogue() -> void:
	NarrativeUtility.queue_dialogue(["Keep taking photos! I believe in you!"], "Mr. Penguin")


func _victory_dialogue() -> void:
	NarrativeUtility.queue_dialogue(["You did it!!!", "Congratulations, you're the peng-winner!", "Thanks for participating in my contest, and I hope you consider joining my future contests!"], "Mr. Penguin")
