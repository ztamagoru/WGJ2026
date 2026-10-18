extends Resource
class_name BachelorResource

# --

@export_category("Identity")
@export var id : StringName
@export var name : String
@export var icon : Texture
@export var portrait : PackedScene

@export_category("Dialogue")
@export var dialogue : DialogueResource
