extends Node

export var enabled := true
export var tilt_ammount := 5.0
export var tilt_acceleration := 4.0

onready var running_tilt = tilt_ammount + Ap.running.custom_FOV if Ap.running.custom_FOV > 0 else tilt_ammount + 4

func _physics_process(delta: float) -> void:
	if enabled:
		print(Ap.camera.rotation_degrees.z)
		Ap.camera.rotation_degrees.z = lerp(Ap.camera.rotation_degrees.z,-(running_tilt if Ap.running.affect_tilt and Input.is_action_pressed("run") else tilt_ammount) * Ap.movement_settings.input.x,delta * tilt_acceleration)
