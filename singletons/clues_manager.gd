extends Node

# --

var unlocked_clues : Dictionary[StringName, Array]

# --

func unlock_clue(bachelor_id : StringName, clue_id : StringName) -> void:
	if not unlocked_clues.has(bachelor_id):
		unlocked_clues[bachelor_id] = []
	
	if unlocked_clues[bachelor_id].has(clue_id): return
	
	unlocked_clues[bachelor_id].append(clue_id)

func get_clues(bachelor_id : StringName) -> Array[String]:
	if not unlocked_clues.has(bachelor_id): return []
	
	var bachelor : BachelorResource = BachelorManager.get_bachelor(bachelor_id)
	if bachelor == null: return []
	
	var clues_descriptions : Array[String] = []
	
	if unlocked_clues[bachelor_id].is_empty(): return []
	
	for clue_id in unlocked_clues[bachelor_id]:
		for clue in bachelor.clues:
			if clue.id == clue_id:
				clues_descriptions.append(clue.description)
				break
	
	return clues_descriptions
