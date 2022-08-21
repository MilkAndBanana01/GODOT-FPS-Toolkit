tool
extends Node

var mouseMovement
var rotationVelocity: Vector2

export var enabled := true
export var sensitivity : int = 1
export var smoothing := true
export(int,0,100) var smoothRate
export var lockCamera := false

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
				AP.player.rotate_y(-deg2rad(rotationVelocity.x))
				get_parent().head.rotate_x(-deg2rad(rotationVelocity.y))
				get_parent().head.rotation.x = clamp(get_parent().head.rotation.x,deg2rad(-90),deg2rad(90))
			mouseMovement = Vector2.ZERO
