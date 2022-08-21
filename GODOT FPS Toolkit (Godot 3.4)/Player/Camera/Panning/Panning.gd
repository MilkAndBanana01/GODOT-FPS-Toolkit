extends "res://Player/Camera/Camera Settings.gd"

export var smoothing_enabled := false
export var smoothing_amount := 25.0

var mouse_movement : Vector2
var rotation_velocity : Vector3

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_movement = event.relative

func _physics_process(delta: float) -> void:
	rotation_velocity = rotation_velocity.linear_interpolate(Vector3(mouse_movement.x,0,mouse_movement.y) * mouse_sensitivity, delta)
	Ap.player.rotate_y(-deg2rad(rotation_velocity.x))
	mouse_movement = Vector2.ZERO
