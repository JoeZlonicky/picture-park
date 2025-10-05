class_name DialogueScreen
extends CanvasLayer


class QueuedDialogue:
	signal started
	signal finished
	
	var title: String = ""
	var dialogue: String = ""
	
	func _init(p_dialogue: String, p_title: String = "") -> void:
		title = p_title
		dialogue = p_dialogue


var _current_dialogue: QueuedDialogue = null
var _queued_dialogue: Array[QueuedDialogue] = []

@onready var _title_label: Label = %TitleLabel
@onready var _dialogue_label: TypedLabel = %DialogueLabel
@onready var _margin_container: MarginContainer = %MarginContainer
@onready var _dialogue_container: Container = %DialogueContainer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _process(_delta: float) -> void:
	if _dialogue_label.is_typing() && not audio_stream_player.playing:
		audio_stream_player.playing = true


func _unhandled_input(event: InputEvent) -> void:
	if not visible or not (event.is_action_pressed("interact") or event.is_action_pressed("camera")):
		return
	
	if _current_dialogue and _dialogue_label.is_typing():
		_dialogue_label.skip_to_end()
	else:
		_next_dialogue()
	get_viewport().set_input_as_handled()


func queue_dialogue(dialogue: String, title: String = "") -> bool:
	var q_dialogue := QueuedDialogue.new(dialogue, title)
	_queued_dialogue.push_back(q_dialogue)
	if not _current_dialogue:
		_next_dialogue()
	await q_dialogue.finished
	return true


func _next_dialogue() -> void:
	if _current_dialogue:
		_current_dialogue.finished.emit()
	
	if not _queued_dialogue:
		_current_dialogue = null
		GameUtility.get_game().pause_input_counter -= 1
		hide()
		return
	
	_current_dialogue = _queued_dialogue.pop_front()
	_dialogue_label.text = _current_dialogue.dialogue
	_dialogue_label.start_typing()
	_title_label.text = _current_dialogue.title
	_title_label.visible = _current_dialogue.title.length() > 0
	_current_dialogue.started.emit()
	if not visible:
		_animate_first_dialogue()
		GameUtility.get_game().pause_input_counter += 1
	
	show()


func _animate_first_dialogue() -> void:
	# Kinda gross but we need to wait for UI to update after being shown
	# By using modulate, instead of hiding, the UI is still correct but doesn't show yet
	_margin_container.modulate = Color.TRANSPARENT
	await get_tree().process_frame
	await get_tree().process_frame
	var dialogue_center := _dialogue_container.get_global_rect().get_center()
	_margin_container.pivot_offset = dialogue_center
	_margin_container.modulate = Color.WHITE
	
	var tween := create_tween()
	tween.tween_property(_margin_container, "scale", Vector2.ONE,
		0.2).from(Vector2.ZERO)
