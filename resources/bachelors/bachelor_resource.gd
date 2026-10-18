extends Resource
class_name BachelorResource

# --

@export_category("Identity")
@export var id : StringName
@export var name : String
@export_multiline() var description : String
@export_multiline() var tidbit : String
@export var icon : Texture
@export var portrait : PackedScene
@export var is_good_bachelor : bool = false

@export_category("Dialogue")
@export var dialogue : DialogueResource

@export_category("Clues")
@export var clues : Array[Clue]
