extends Node

# --

var decision_screen : PackedScene = preload("res://scenes/decision_screen.tscn")

const BACHELORS_PATH : String = "res://resources/bachelors/"

var bachelors : Array[BachelorResource] = []

var current_bachelor : BachelorResource

# --

func _ready() -> void:
	_load_bachelors_from_directory(BACHELORS_PATH)
	start_speed_dating()

func _load_bachelors_from_directory(path : String) -> void:
	var entries : PackedStringArray = ResourceLoader.list_directory(path)
	
	for entry in entries:
		var entry_path : String = path.path_join(entry)
		
		if entry.ends_with("/"):
			_load_bachelors_from_directory(entry_path.trim_suffix("/"))
			continue
		
		if entry.get_extension() != "tres":
			continue
		
		var resource : Resource = load(entry_path)
		if resource is BachelorResource: bachelors.append(resource)

# --

func start_speed_dating() -> void:
	if bachelors.is_empty():
		push_error("BACHELOR MANAGER: No bachelors loaded.")
		return
	
	bachelors.shuffle()
	
	current_bachelor = bachelors[0]
	
	var screen := decision_screen.instantiate() as DecisionScreen
	get_tree().current_scene.add_child(screen)

# --
