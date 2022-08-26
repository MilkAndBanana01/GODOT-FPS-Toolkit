extends Node

export var enabled := true
export var minimum_FOV := 0.0
export var maximum_FOV := 0.0

var running_FOV : float

func _ready() -> void:
	Ap.dynamic_FOV = self
	if minimum_FOV == 0:
		minimum_FOV = Ap.camera.fov
		if Ap.camera_settings.custom_FOV != 0:
			minimum_FOV = Ap.camera_settings.custom_FOV
	if maximum_FOV == 0:
		maximum_FOV = minimum_FOV + 10
	running_FOV = Ap.running.custom_FOV if Ap.running.custom_FOV > 0 else maximum_FOV + 20

func _physics_process(delta: float) -> void:
	if enabled:
		var movement = (Ap.movement_settings.velocity.length() / Ap.movement_settings.speed) + abs(Ap.gravity.gravity.y / Ap.gravity.gravity_limit)
		var current_FOV = clamp(
			(maximum_FOV * movement 
			if Ap.running.enabled and not (Input.is_action_pressed("run") and not Ap.flying.minecraft_style or Input.is_key_pressed(KEY_CONTROL) and Ap.flying.minecraft_style)
			else running_FOV * movement),
			minimum_FOV,
			running_FOV)
		Ap.camera.fov = lerp(Ap.camera.fov,current_FOV,delta * 4)
