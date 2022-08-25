extends Node

export var enabled := true
export var speed := 10.0
export var acceleration := 1
export var affect_FOV := true
export var custom_FOV := 0

func _enter_tree() -> void:
	Ap.running = self
