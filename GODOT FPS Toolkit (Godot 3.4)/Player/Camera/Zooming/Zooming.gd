extends Node

export var zooming_enabled := false
export var toggle_mode := false
export var zoom_fov := 5.0
export var smoothing_enabled := true
export(float,0,10) var smoothing_amount := 5.0
export var affect_mouse_sensitivity := true
export var mouse_desensitivity_rate := 4.0

onready var camera = Ap.player.get_node("Head/Camera")

var current_sensitivity
var current_fov
var zoomedIn := false
var enable_zoom : bool

func _ready() -> void:
	current_sensitivity = Ap.camera_settings.mouse_sensitivity
	current_fov = camera.fov
	Ap.camera_zooming = self

func _input(_event) -> void:
	if Input.is_action_just_pressed("zoom"):
		zoomedIn = !zoomedIn

func _physics_process(delta: float) -> void:
	enable_zoom = (Input.is_action_pressed("zoom") and not toggle_mode) or (zoomedIn and toggle_mode)
	camera.fov = lerp(camera.fov,zoom_fov if enable_zoom else current_fov,
	delta * (10.1 - smoothing_amount) if smoothing_enabled else 1)
