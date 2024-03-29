extends Node

export var smoothing_enabled := false
export(float,0,10) var smoothing_amount := 5.0
export var lock_camera := false

var mouse_movement : Vector2
var rotation_velocity : Vector2
var current_sensitivity

func _ready() -> void:
	Ap.camera_panning = self

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not lock_camera:
		mouse_movement = event.relative

func _physics_process(delta: float) -> void:
	interpolate_mouse_movement(delta)
	move_camera()

func interpolate_mouse_movement(delta):
	current_sensitivity =  Ap.camera_settings.mouse_sensitivity/Ap.camera_zooming.mouse_desensitivity_rate if Ap.camera_zooming.enable_zoom else Ap.camera_settings.mouse_sensitivity
	rotation_velocity = rotation_velocity.linear_interpolate(Vector2(mouse_movement.x * current_sensitivity,mouse_movement.y * current_sensitivity), 
	delta * (10.1 - smoothing_amount) if smoothing_enabled else 1)

func move_camera():
	Ap.player.rotate_y(-deg2rad(rotation_velocity.x))
	Ap.head.rotate_x(-deg2rad(rotation_velocity.y))
	Ap.head.rotation.x = clamp(Ap.head.rotation.x,deg2rad(-90),deg2rad(90))
	mouse_movement = Vector2.ZERO
