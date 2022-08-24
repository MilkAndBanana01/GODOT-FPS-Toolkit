extends Node

export var enabled := true
export var tilt_ammount := 5.0
export var tilt_acceleration := 4.0

func _physics_process(delta: float) -> void:
	if enabled:
		Ap.camera.rotation_degrees.z = lerp(Ap.camera.rotation_degrees.z,-tilt_ammount * Ap.movement_settings.input.x,delta * tilt_acceleration)
