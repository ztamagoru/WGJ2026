extends DialogueBalloon

# --

const SLOT_LEFT = 0
const SLOT_RIGHT = 1

# --

@onready var slot_0: Marker2D = $Balloon/Stage/Slot0
@onready var slot_1: Marker2D = $Balloon/Stage/Slot1

# --

var slots : Array[Marker2D] = []
var characters : Dictionary[String, Node2D]

# --

func _ready() -> void:
	slots = [slot_0, slot_1]
	super()

# --

func add_character(character_name : String, slot_index : int) -> void:
	var slot = slots[slot_index]
	
	var character : Node2D = load("res://scenes/dialogue/characters/%s.tscn" % [character_name]).instantiate()
	slot.add_child(character)
	
	if slot_index == SLOT_RIGHT:
		character.scale = Vector2(-1, 1)
	
	var tween : Tween = create_tween()
	tween.tween_property(character, "modulate:a", 1, 0.5).from(0)
	await tween.finished
	
	characters[character_name] = character

func remove_character(character_name : String) -> void:
	if not characters.has(character_name): return
	
	var character : Node2D = characters.get(character_name)
	
	var tween : Tween = create_tween()
	tween.tween_property(character, "modulate:a", 0, 0.5).from(1)
	await tween.finished
	
	character.queue_free()
	characters.erase(character_name)
