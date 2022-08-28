extends Node

export var jumping_enabled := true
export var jump_height := 20.0
export var maximum_jumps := 1
export var update_direction := true


func _ready() -> void:
	Ap.jumping = self


func jump():
	if Input.is_action_just_pressed("jump") and Ap.gravity.jump_count < maximum_jumps:
		Ap.gravity.jump_count += 1
		Ap.gravity.snap = Vector3.ZERO
		Ap.gravity.gravity = Vector3.UP * Ap.jumping.jump_height
		if Ap.jumping.update_direction:
			Ap.movement_settings.updateDirection()
			Ap.movement_settings.retroMovement(Ap.walking.speed)
	elif Ap.gravity.snap != Vector3.ZERO:
		Ap.gravity.jump_count = 0
