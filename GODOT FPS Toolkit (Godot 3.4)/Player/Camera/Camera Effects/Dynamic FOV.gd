extends Node

export var enabled := true
export var minimum_FOV := 0
export var maximum_FOV := 0


func _ready() -> void:
	Ap.dynamic_FOV = self
	if minimum_FOV == 0:
		minimum_FOV = Ap.camera.fov
		if Ap.camera_settings.custom_FOV != 0:
			minimum_FOV = Ap.camera_settings.custom_FOV
	if maximum_FOV == 0:
		maximum_FOV = minimum_FOV + 10


func _physics_process(delta: float) -> void:
	if enabled:
		var moving = bool(Ap.movement_settings.velocity.length())
		if not Ap.camera_zooming.enable_zoom:
			Ap.camera.fov = lerp(Ap.camera.fov,maximum_FOV if int(moving) > 0 else minimum_FOV, delta * 4)
