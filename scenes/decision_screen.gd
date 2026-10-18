extends CanvasLayer
class_name DecisionScreen

# --

@onready var screen : Control = $Screen
@onready var slot_0 : Node2D = $Screen/Stage/Slot0

@onready var investigation_screen : InvestigationScreen = $InvestigationScreen

# --

func _ready() -> void:
	var current_bachelor = BachelorManager.current_bachelor
	
	var portrait := current_bachelor.portrait.instantiate() as BachelorPortait
	slot_0.add_child(portrait)

func _on_ask_pressed() -> void:
	# Abrir ventana nueva con dos opciones:
	# Preguntar sobre disfraz, preguntar sobre vida
	pass


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
