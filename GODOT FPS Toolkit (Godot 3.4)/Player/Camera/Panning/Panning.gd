extends "res://Player/Camera/Camera Settings.gd"

export var smoothing_enabled := false
export(float,0,10) var smoothing_amount := 5.0

var mouse_movement : Vector2
var rotation_velocity : Vector2

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_movement = event.relative

func _physics_process(delta: float) -> void:
	rotation_velocity = rotation_velocity.linear_interpolate(Vector2(mouse_movement.x,mouse_movement.y) * mouse_sensitivity, 
	delta * (10.1 - smoothing_amount) if smoothing_enabled else 1)
	Ap.player.rotate_y(-deg2rad(rotation_velocity.x))
	head.rotate_x(-deg2rad(rotation_velocity.y))
	head.rotation.x = clamp(head.rotation.x,deg2rad(-90),deg2rad(90))
	mouse_movement = Vector2.ZERO