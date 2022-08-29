extends Node

export var enabled := true
export var enable_ledge_grab := true
export var custom_speed := 0

onready var speed = custom_speed if custom_speed > 0 else Ap.walking.speed

var is_climbing := false
var climbing_vector : Vector3

func _enter_tree() -> void:
	Ap.climbing = self

func climb():
	if Ap.player.is_on_wall():
		Ap.gravity.enabled = false
		Ap.walking.enabled = false
		var wall_normal = Ap.player.get_slide_collision(0)
		climbing_vector = -wall_normal.normal * speed
		climbing_vector.y = (Input.get_action_strength("move_forward") - Input.get_action_strength("move_back")) * speed
		Ap.player.move_and_slide(climbing_vector,Vector3.UP)
		
	elif not Ap.player.is_on_wall():
		Ap.gravity.enabled = true
