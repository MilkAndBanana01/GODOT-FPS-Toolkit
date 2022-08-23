extends Node

export var jumping_enabled := true
export var jump_height := 5.0
export var maximum_jumps := 1

var jump : Vector3

func _ready() -> void:
	Ap.jumping = self

