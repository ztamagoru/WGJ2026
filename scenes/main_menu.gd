extends CanvasLayer

# --

@export_file_path("*.tscn") var game_scene_path : String

# --

var scene_manager : SceneManager

# --

func _on_start_pressed() -> void:
	scene_manager.change_scene(game_scene_path, true)
	$Control/MarginContainer/Start.disabled = true
