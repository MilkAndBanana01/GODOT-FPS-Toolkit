extends "res://Player/Camera/Camera Settings.gd"

export var zooming_enabled := false
export var zoom_fov := 5.0
export var smoothing_enabled := true
export(float,0,10) var smoothing_amount := 5.0
export var affect_mouse_sensitivity := true
export var mouse_desensitivity_rate := 4.0
onready var camera = Ap.player.get_node("Head/Camera")
var current_fov
var current_sensitivity
func _ready() -> void:
	current_fov = camera.fov
	current_sensitivity = mouse_sensitivity
	Ap.camera_zooming = self

func _physics_process(delta: float) -> void:
	camera.fov = lerp(camera.fov,zoom_fov if Input.is_action_pressed("zoom") else current_fov,
	delta * (10.1 - smoothing_amount) if smoothing_enabled else 1)
	mouse_sensitivity = lerp(mouse_sensitivity,(current_sensitivity / 100) if Input.is_action_pressed("zoom") else mouse_sensitivity,
	delta)
