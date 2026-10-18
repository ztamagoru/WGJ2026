extends CharacterBody3D
class_name Actor

# --

@onready var sprite : Sprite3D = $Sprite3D

@onready var center : Vector3 = global_position

# --

func _physics_process(delta: float) -> void:
	movement_process(delta)
	visuals_process(delta)

func movement_process(delta : float) -> void:
	velocity = Vector3.LEFT
	move_and_slide()

func visuals_process(delta : float) -> void:
	var desired_rot_y = 180 if velocity.x < 0 else 0
	rotation_degrees.y = lerpf(rotation_degrees.y, desired_rot_y, 5 * delta)
