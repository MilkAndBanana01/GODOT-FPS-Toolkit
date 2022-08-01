tool
extends "res://Player/Abilities/Camera/Camera.gd"

var mouseMovement
var rotationVelocity: Vector2

export var enabled := true
export var sensitivity : int = 1
export var smoothing := true
export(int,0,100) var smoothRate
export var lockCamera := false

func _ready():
	if not Engine.editor_hint:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouseMovement = event.relative
	else:
		mouseMovement = Vector2.ZERO
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint() == false:
		if mouseMovement != null:
			if smoothing:
				rotationVelocity = rotationVelocity.linear_interpolate(mouseMovement * (sensitivity * 0.25), (100.5 - smoothRate) * .01)
			else:
				rotationVelocity = mouseMovement * (sensitivity * 0.25)
			if not lockCamera:
				player.rotate_y(-deg2rad(rotationVelocity.x))
				head.rotate_x(-deg2rad(rotationVelocity.y))
				head.rotation.x = clamp(head.rotation.x,deg2rad(-90),deg2rad(90))
			mouseMovement = Vector2.ZERO
