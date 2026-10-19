extends CanvasLayer

# --

@export_file_path("*.tscn") var game_scene_path : String

# --

var scene_manager : SceneManager

# --

func _on_start_pressed() -> void:
	DialogueManager.show_dialogue_balloon(load("res://resources/bachelors/start.dialogue"))
	DialogueManager.dialogue_ended.connect(func(x):
		scene_manager.change_scene(game_scene_path)
		$Control/MarginContainer/Start.disabled = true, CONNECT_ONE_SHOT)
	
