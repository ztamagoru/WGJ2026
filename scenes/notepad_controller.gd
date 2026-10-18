extends Control
class_name NotepadController

# --

@onready var bachelor_name_label : Label		= $BachelorName
@onready var bachelor_description_label : Label = $BachelorDescription
@onready var bachelor_tidbit_label : Label		= $BachelorTidbit
@onready var bachelor_icon : TextureRect		= $BachelorIcon

@onready var previous_bachelor_button : BaseButton	= $LeftButton
@onready var next_bachelor_button : BaseButton		= $RightButton

@onready var clues_container : Container	= $ScrollContainer/VBoxContainer

# --

var clue_scene : PackedScene = preload("res://scenes/notepad_clue.tscn")

# --

var current_bachelor : BachelorResource

var bachelor_index : int = 0:
	set(value):
		var bachelors_count : int = BachelorManager.all_bachelors.size()
		if bachelors_count == 0: return
		
		bachelor_index = (value % bachelors_count + bachelors_count) % bachelors_count
		_update_page()

# --

func _ready() -> void:
	previous_bachelor_button.pressed.connect(func(): bachelor_index -= 1)
	next_bachelor_button.pressed.connect(func(): bachelor_index += 1)
	
	CluesManager.clue_unlocked.connect(func(): _update_page())
	
	_update_page()

func _update_page() -> void:
	current_bachelor = BachelorManager.all_bachelors[bachelor_index]
	
	for child in clues_container.get_children():
		child.queue_free()
	
	bachelor_name_label.text = current_bachelor.name
	bachelor_description_label.text = current_bachelor.description
	bachelor_tidbit_label.text = current_bachelor.tidbit
	if current_bachelor.icon != null: bachelor_icon.texture = current_bachelor.icon
	
	var bachelor_clues = CluesManager.get_clues(current_bachelor.id)
	if bachelor_clues.is_empty(): return
	
	for clue in bachelor_clues:
		var notepad_clue := clue_scene.instantiate() as NotepadClue
		clues_container.add_child(notepad_clue)
		print(clue)
		print(clue.contradicts)
		notepad_clue.load_clue(clue)
		notepad_clue.clicked.connect(on_clue_clicked)

func on_clue_clicked(clue : Clue) -> void:
	print(clue)
	print("%s and %s" % [clue.contradicts, BachelorManager.current_bachelor.id])
	if clue.contradicts == BachelorManager.current_bachelor.id:
		DialogueManager.show_dialogue_balloon(BachelorManager.current_bachelor.dialogue, "accusation_correct")
	else:
		DialogueManager.show_dialogue_balloon(BachelorManager.current_bachelor.dialogue, "accusation_incorrect")
