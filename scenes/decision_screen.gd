extends CanvasLayer
class_name DecisionScreen

# --

@onready var screen : Control = $Screen
@onready var slot_0 : Node2D = $Screen/Stage/Slot0

@onready var investigation_screen : InvestigationScreen = $InvestigationScreen

# --

@onready var buttons_container : MarginContainer			= $Screen/MarginContainer

@onready var initial_buttons_container : HBoxContainer		= $Screen/MarginContainer/InitialQuestions
@onready var specific_questions_container : HBoxContainer	= $Screen/MarginContainer/SpecificQuestions
@onready var characters_questions_container : GridContainer = $Screen/MarginContainer/CharacterQuestions

@onready var ask_costume : Button		= $Screen/MarginContainer/SpecificQuestions/AskCostume
@onready var ask_life : Button			= $Screen/MarginContainer/SpecificQuestions/AskLife
@onready var ask_about_someone : Button = $Screen/MarginContainer/SpecificQuestions/AskSomeoneElse

# --

func _ready() -> void:
	var current_bachelor = BachelorManager.current_bachelor
	
	var portrait := current_bachelor.portrait.instantiate() as BachelorPortait
	slot_0.add_child(portrait)
	
	ask_costume.pressed.connect(_ask_question.bind("costume"))
	ask_life.pressed.connect(_ask_question.bind("personal"))
	
	DialogueManager.dialogue_started.connect(func(x): buttons_container.hide())
	DialogueManager.dialogue_ended.connect(func(x): buttons_container.show())

func _on_ask_pressed() -> void:
	initial_buttons_container.visible = false
	specific_questions_container.visible = true

func _ask_question(about : String) -> void:
	initial_buttons_container.visible = true
	specific_questions_container.visible = false
	characters_questions_container.visible = false
	
	DialogueManager.show_dialogue_balloon(BachelorManager.current_bachelor.dialogue, "question_%s" % about)
	
	if characters_questions_container.get_child_count() > 0:
		for child in characters_questions_container.get_children(): child.queue_free()


func _on_ask_someone_else_pressed() -> void:
	specific_questions_container.visible = false
	characters_questions_container.visible = true
	
	for bachelor in BachelorManager.all_bachelors:
		if bachelor == BachelorManager.current_bachelor: continue
		
		var new_button : Button = _create_button()
		new_button.icon = bachelor.icon
		
		print(str(bachelor.id))
		new_button.pressed.connect(_ask_question.bind(str(bachelor.id)))
		characters_questions_container.add_child(new_button)
	
	var back_button : Button = _create_button()
	back_button.text = "Atrás"
	
	back_button.pressed.connect(_go_back_questions)
	characters_questions_container.add_child(back_button)

func _go_back_questions() -> void:
	for child in characters_questions_container.get_children(): child.queue_free()
	specific_questions_container.visible = true
	characters_questions_container.visible = false

func _create_button() -> Button:
	var new_button : Button = Button.new()
	
	new_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	new_button.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	return new_button

func _on_back_pressed() -> void:
	initial_buttons_container.visible = true
	specific_questions_container.visible = false


# --


func _on_investigate_pressed() -> void:
	screen.hide()
	investigation_screen.show()


func _on_choose_pressed() -> void:
	pass


func _on_reject_pressed() -> void:
	pass


func _on_investigation_screen_exited() -> void:
	screen.show()
	investigation_screen.hide()
