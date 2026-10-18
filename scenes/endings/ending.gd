extends Node
class_name Ending

#--

enum EndingType { GOOD, BAD, ALONE }

# --

@onready var ending_illustration : TextureRect = $CanvasLayer/Control/EndingIllustration

# --

var good_ending_texture : Texture = load("res://assets/endings/wcena_final_1_2.png")
var bad_ending_texture : Texture
var alone_ending_texture : Texture

var current_image : Texture = null:
	set(value):
		current_image = value
		ending_illustration.texture = value

# --

var alone_dialogue : DialogueResource = load("res://resources/bachelors/alone.dialogue")

# --

var scene_manager : SceneManager

var showing_dialog : bool = false

var main_menu : String = "res://scenes/main_menu.tscn"

# --

func _ready() -> void:
	DialogueManager.dialogue_started.connect(func(_arg): showing_dialog = true)
	DialogueManager.dialogue_ended.connect(func(_arg): showing_dialog = false)

func show_ending():
	var ending_type : EndingType
	
	if BachelorManager.bachelors.size() == 0: ending_type = EndingType.ALONE
	else:
		if BachelorManager.current_bachelor.is_good_bachelor: ending_type = EndingType.GOOD
		else: ending_type = EndingType.BAD
	
	match ending_type:
		EndingType.GOOD: 
			current_image = good_ending_texture
			_show_ending()
		
		EndingType.BAD:
			current_image = bad_ending_texture
			_show_ending()
		
		EndingType.ALONE:
			current_image = alone_ending_texture
			_show_alone_ending()

# --

func _show_ending() -> void:
	await _fade_ending_image()
	DialogueManager.show_dialogue_balloon(BachelorManager.current_bachelor.dialogue, "chosen")

func _show_alone_ending() -> void:
	await _fade_ending_image()
	DialogueManager.show_dialogue_balloon(alone_dialogue)

# --

func _fade_ending_image() -> void:
	var fade_tween : Tween = create_tween()
	
	fade_tween.set_trans(Tween.TRANS_CUBIC)
	fade_tween.set_ease(Tween.EASE_IN_OUT)
	
	fade_tween.tween_property(ending_illustration, "modulate:a", 1, 1.0)
	await fade_tween.finished

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if not showing_dialog: scene_manager.change_scene(main_menu, true)
