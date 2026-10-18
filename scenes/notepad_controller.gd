extends Control
class_name NotepadController

# --

@onready var bachelor_name_label : Label		= $VBoxContainer/HBoxContainer/VBoxContainer/BachelorName
@onready var bachelor_description_label : Label = $VBoxContainer/HBoxContainer/VBoxContainer/BachelorDescription
@onready var bachelor_icon : TextureRect		= $VBoxContainer/HBoxContainer/MarginContainer/BachelorIcon

@onready var previous_bachelor_button : Button	= $VBoxContainer/HBoxContainer2/PreviousBachelorButton
@onready var next_bachelor_button : Button		= $VBoxContainer/HBoxContainer2/NextBachelorButton

@onready var clues_container : HFlowContainer	= $VBoxContainer/MarginContainer/ScrollContainer/CluesContainer

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
	if not current_bachelor.icon == null: bachelor_icon.texture = current_bachelor.icon
	
	var bachelor_clues : Array[String] = CluesManager.get_clues(current_bachelor.id)
	if bachelor_clues.is_empty(): return
	
	for clue in bachelor_clues:
		var clue_description : Label = Label.new()
		clue_description.text = clue
		clues_container.add_child(clue_description)
