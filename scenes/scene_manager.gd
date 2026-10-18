extends Node3D
class_name SceneManager

# --

enum fade_mode { FADE_IN, FADE_OUT }

# --

@export_file_path("*.tscn") var main_menu : String

@export var current_scene : Node3D

@export_group("Fade", "fade_")
@export var fade_layer : ColorRect
@export var fade_duration : float = 1.0
@export var fade_loading_icon : TextureRect

# --

func _ready() -> void:
	BachelorManager.scene_manager = self
	change_scene(main_menu)
	
	var tween := create_tween()
	tween.set_loops()
	tween.tween_property(fade_loading_icon, "rotation", TAU, 1.0).from(0.0)

# --

func change_scene(scene : String) -> void:
	await _fade(fade_mode.FADE_IN)
	
	for child in current_scene.get_children(): child.queue_free()
	
	await _fade(fade_mode.FADE_IN, fade_loading_icon, 0.5)
	var new_scene = load(scene)
	var scene_instance = new_scene.instantiate()
	current_scene.add_child(scene_instance)
	
	await _fade(fade_mode.FADE_OUT, fade_loading_icon, 0.5)
	
	if scene_instance.has_method("start_dating"): scene_instance.start_dating()
	
	if ("scene_manager" in scene_instance): scene_instance.scene_manager = self
	
	if scene_instance is Ending: scene_instance.show_ending()
	
	await _fade(fade_mode.FADE_OUT)

# --

func _fade(mode : fade_mode, target : Control = fade_layer, duration : float = fade_duration) -> void:
	var fade_tween : Tween = create_tween()
	
	fade_tween.set_trans(Tween.TRANS_CUBIC)
	fade_tween.set_ease(Tween.EASE_IN_OUT)
	
	var new_a : float = 1.0 if mode == fade_mode.FADE_IN else 0.0
	fade_tween.tween_property(target, "modulate:a", new_a, duration)
	await fade_tween.finished
