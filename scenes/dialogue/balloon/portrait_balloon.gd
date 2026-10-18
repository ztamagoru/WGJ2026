extends DialogueBalloon

# --

const SLOT_LEFT = 0
const SLOT_RIGHT = 1

# --

@onready var slot_0: Marker2D = $Balloon/Stage/Slot0
@onready var slot_1: Marker2D = $Balloon/Stage/Slot1

# --

var slots : Array[Marker2D] = []
var portraits : Dictionary[String, Node2D]

# --

func _ready() -> void:
	slots = [slot_0, slot_1]
	super()

# --

func add_character(bachelor_name : String, slot_index : int) -> void:
	var slot = slots[slot_index]
	
	var bachelor : BachelorResource = load("res://resources/bachelors/%s.tres" % [bachelor_name])
	var portait : BachelorPortait = bachelor.portrait.instantiate()
	slot.add_child(portait)
	
	if slot_index == SLOT_RIGHT:
		portait.scale = Vector2(-1, 1)
	
	var tween : Tween = create_tween()
	tween.tween_property(portait, "modulate:a", 1, 0.5).from(0)
	await tween.finished
	
	portraits[bachelor_name] = portait

func remove_character(bachelor_name : String) -> void:
	if not portraits.has(bachelor_name): return
	
	var portrait : BachelorPortait = portraits.get(bachelor_name)
	
	var tween : Tween = create_tween()
	tween.tween_property(portrait, "modulate:a", 0, 0.5).from(1)
	await tween.finished
	
	portrait.queue_free()
	portraits.erase(bachelor_name)
