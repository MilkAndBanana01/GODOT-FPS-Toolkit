extends Node

export var enable_air_momentum := true
export var enable_air_movement := false
export var custom_air_speed := 0.0
export var custom_air_acceleration := 0.0

onready var enabled = bool(enable_air_momentum or enable_air_movement)

func _ready() -> void:
	Ap.mid_air_settings = self

