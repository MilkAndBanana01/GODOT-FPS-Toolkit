extends Node

export var enabled := true
export var speed := 20.0
export var acceleration := 1.0

func _ready() -> void:
	Ap.walking = self

func _physics_process(delta: float) -> void:
	if enabled:
		Ap.movement_settings.current_speed = speed + Ap.mid_air_settings.custom_air_speed if Ap.mid_air_settings.enabled else speed
		Ap.movement_settings.current_acceleration = acceleration + Ap.mid_air_settings.custom_air_acceleration if Ap.mid_air_settings.enabled else acceleration
