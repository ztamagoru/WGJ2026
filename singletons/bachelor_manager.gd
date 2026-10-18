extends Node

# --

signal speed_dating_started()

signal bachelor_started()
signal bachelor_finished()

# --

const GOOD_ENDING_SCENE : String = "res://scenes/endings/good_ending.tscn"
const BAD_ENDING_SCENE : String = "res://scenes/endings/bad_ending.tscn"
const ALONE_ENDING_SCENE : String = "res://scenes/endings/alone_ending.tscn"

const BACHELORS_PATH : String = "res://resources/bachelors/"

# --

var decision_screen : PackedScene = preload("res://scenes/decision_screen.tscn")
var current_decision_screen : DecisionScreen

var scene_manager : SceneManager

var all_bachelors : Array[BachelorResource] = []
var bachelors : Array[BachelorResource] = []

var current_bachelor : BachelorResource:
	set(value):
		current_bachelor = value
		if current_bachelor == null: _delete_decision_scene()
		else: _create_decision_scene()

var remaining_interactions : int 
const max_interactions : int = 3

# --

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_bachelor_interaction)
	
	_load_bachelors_from_directory(BACHELORS_PATH)

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
		if resource is BachelorResource: all_bachelors.append(resource)

# --

func get_bachelor(bachelor_id : StringName) -> BachelorResource:
	for bachelor in all_bachelors:
		if bachelor.id == bachelor_id: return bachelor
	
	return null

# --

func start_speed_dating() -> void:
	if all_bachelors.is_empty():
		push_error("BACHELOR MANAGER: No bachelors loaded.")
		return
	
	
	bachelors = all_bachelors.duplicate()
	bachelors.shuffle()
	
	speed_dating_started.emit()
	_set_new_bachelor()

func reject_bachelor() -> void:
	if current_bachelor == null: return
	
	
	bachelor_finished.emit()
	current_bachelor = null
	bachelors.pop_front()
	
	if bachelors.is_empty():
		if scene_manager == null:
			push_error("BACHELOR MANAGER: GameManager not assigned.")
			return
		
		scene_manager.change_scene(ALONE_ENDING_SCENE)
		return
	
	_set_new_bachelor()

func accept_bachelor() -> void:
	if current_bachelor == null: return
	
	if scene_manager == null:
		push_error("BACHELOR MANAGER: GameManager not assigned.")
		return
	
	if current_bachelor.is_good_bachelor: scene_manager.change_scene(GOOD_ENDING_SCENE)
	else: scene_manager.change_scene(BAD_ENDING_SCENE)
	return 

# --

func _bachelor_interaction(_resource : DialogueResource) -> void:
	if current_bachelor == null: return
	if bachelors.size() == 1: return
	
	remaining_interactions -= 1
	if remaining_interactions == 0: _get_next_bachelor()

# --

func _get_next_bachelor() -> void:
	bachelor_finished.emit()
	
	current_bachelor = null
	
	var finished_bachelor: BachelorResource = bachelors.pop_front()
	bachelors.push_back(finished_bachelor)
	
	_set_new_bachelor()

# --

func _set_new_bachelor() -> void:
	current_bachelor = bachelors[0]
	remaining_interactions = max_interactions
	
	bachelor_started.emit()

# --

func _create_decision_scene() -> void:
	current_decision_screen = decision_screen.instantiate() as DecisionScreen
	scene_manager.current_scene.add_child(current_decision_screen)
	await get_tree().process_frame
	current_decision_screen.choose_button.visible = (bachelors.size() == 1)

func _delete_decision_scene() -> void:
	if not current_decision_screen == null:
				current_decision_screen.queue_free()
				current_decision_screen = null
