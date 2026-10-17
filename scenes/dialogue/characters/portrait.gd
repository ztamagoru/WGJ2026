extends Node2D
class_name BachelorPortait

# --

signal clue_selected(clue_name : String)

# --

@export var clues : Array[ClueArea]

# --

func _ready() -> void:
	for clue in clues:
		clue.clue_clicked.connect(clue_selected.emit)
