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
	
	_update_page()

func _update_page() -> void:
	current_bachelor = BachelorManager.all_bachelors[bachelor_index]
	
	for child in clues_container.get_children():
		child.queue_free()
	
	bachelor_name_label.text = current_bachelor.name
	bachelor_description_label.text = current_bachelor.description
	if current_bachelor.icon != null: bachelor_icon.texture = current_bachelor.icon
	
	var bachelor_clues : Array[String] = CluesManager.get_clues(current_bachelor.id)
	if bachelor_clues.is_empty(): return
	
	for clue in bachelor_clues:
		var clue_description : Label = Label.new()
		clue_description.text = clue
		clues_container.add_child(clue_description)
