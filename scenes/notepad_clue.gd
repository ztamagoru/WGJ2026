extends Control
class_name NotepadClue

# --

signal clicked(clue : Clue)

# --

@onready var clue_label : Label = %ClueLabel

# --

var source_clue : Clue

func load_clue(clue : Clue) -> void:
	clue_label.text = clue.description
	
	source_clue = clue

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			clicked.emit(source_clue)
