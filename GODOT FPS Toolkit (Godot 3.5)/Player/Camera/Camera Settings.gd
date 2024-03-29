extends Node

export var enable := true
export var mouse_sensitivity := 1.0
export var custom_FOV := 0

func _enter_tree() -> void:
	Ap.camera_settings = self

func _ready() -> void:
	if enable:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		Ap.camera.fov = custom_FOV if custom_FOV != 0 else 70

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_key_pressed(KEY_ESCAPE):
			get_tree().quit()
