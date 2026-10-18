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

# --

func _ready() -> void:
	BachelorManager.scene_manager = self
	change_scene(main_menu)

# --

func change_scene(scene : String, wait_timer : bool = false) -> void:
	await _fade(fade_mode.FADE_IN)
	
	for child in current_scene.get_children(): child.queue_free()
	
	var new_scene = load(scene)
	var scene_instance = new_scene.instantiate()
	current_scene.add_child(scene_instance)
	
	if wait_timer:
		await get_tree().create_timer(1.0).timeout
	
	if scene_instance.has_method("start_dating"): scene_instance.start_dating()
	if ("scene_manager" in scene_instance): scene_instance.scene_manager = self
	
	await _fade(fade_mode.FADE_OUT)

# --

func _fade(mode : fade_mode) -> void:
	var fade_tween : Tween = create_tween()
	
	fade_tween.set_trans(Tween.TRANS_CUBIC)
	fade_tween.set_ease(Tween.EASE_IN_OUT)
	
	var new_a : float = 1.0 if mode == fade_mode.FADE_IN else 0.0
	fade_tween.tween_property(fade_layer, "modulate:a", new_a, fade_duration)
	await fade_tween.finished
