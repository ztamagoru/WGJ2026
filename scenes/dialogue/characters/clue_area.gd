extends Area2D
class_name ClueArea

# --

signal clue_clicked(name : StringName)

# --

@export var clue_name : StringName

# --

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			clue_clicked.emit(clue_name)

func _mouse_enter() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _mouse_exit() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
