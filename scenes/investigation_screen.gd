extends Control

# --

@onready var portrait_holder : Node2D = $PortraitHolder

@onready var intial_portrait_pos : Vector2 = portrait_holder.global_position

# --

func _process(delta: float) -> void:
	var screen_size = get_viewport().get_visible_rect().size
	var centered_mouse = get_viewport().get_mouse_position() - screen_size * 0.5
	
	portrait_holder.global_position = intial_portrait_pos + Vector2(centered_mouse.x * 0.25, centered_mouse.y) * -5
	portrait_holder.global_position.y = clamp(portrait_holder.global_position.y, screen_size.y, INF)
