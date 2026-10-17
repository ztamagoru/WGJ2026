extends Control
class_name InvestigationScreen

# --

signal exited

# --

@onready var portrait_holder : Node2D = $PortraitHolder

@onready var intial_portrait_pos : Vector2 = portrait_holder.global_position

# --

var in_dialogue : bool

# --

func _ready() -> void:
	var portait := BachelorManager.current_bachelor.portrait.instantiate() as BachelorPortait
	portrait_holder.add_child(portait)
	portait.clue_selected.connect(_on_clue_selected)
	
	DialogueManager.dialogue_started.connect(func(arg): in_dialogue = true)
	DialogueManager.dialogue_ended.connect(func(arg): in_dialogue = false)

func _physics_process(delta: float) -> void:
	if in_dialogue:
		return
	
	var screen_size = get_viewport().get_visible_rect().size
	var centered_mouse = get_viewport().get_mouse_position() - screen_size * 0.5
	
	var desired_pos : Vector2 = intial_portrait_pos + Vector2(centered_mouse.x * 0.25, centered_mouse.y) * -5
	portrait_holder.global_position = lerp(portrait_holder.global_position, desired_pos, 1 * delta)
	portrait_holder.global_position.y = clamp(portrait_holder.global_position.y, screen_size.y, INF)

# --

func _on_clue_selected(clue_name : String) -> void:
	DialogueManager.show_dialogue_balloon(BachelorManager.current_bachelor.dialogue, "investigation_%s" % clue_name)


func _on_exit_pressed() -> void:
	exited.emit()
