extends "res://Player/Camera/Camera Settings.gd"

export var zooming_enabled := false
export var zoom_fov := 5.0
export var smoothing_enabled := true
export(float,0,10) var smoothing_amount := 5.0

onready var camera = Ap.player.get_node("Head/Camera")
var current_fov

func _ready() -> void:
	current_fov = camera.fov

func _physics_process(delta: float) -> void:
	camera.fov = lerp(camera.fov,zoom_fov if Input.is_action_pressed("zoom") else current_fov,
	delta * (10.1 - smoothing_amount) if smoothing_enabled else 1)
