extends Node

export var enabled := true
export var gravity_rate := 1.0
export var gravity_limit := 0

var gravity : Vector3
var snap : Vector3

var momentum : Vector3

var jump_count := 0


func _ready() -> void:
	Ap.gravity = self
	gravity_limit = gravity_limit if gravity_limit > 0 else 50 


func _physics_process(delta: float) -> void:
	if enabled:
		gravity = (gravity + (Vector3.DOWN * gravity_rate)) if snap == Vector3.ZERO else Vector3.ZERO
		gravity.y = clamp(gravity.y,-gravity_limit,INF)
		snap = -Ap.player.get_floor_normal() if Ap.player.is_on_floor() else Vector3.ZERO
		if Input.is_action_just_pressed("jump") and jump_count < Ap.jumping.maximum_jumps:
			jump_count += 1
			snap = Vector3.ZERO
			gravity = Vector3.UP * Ap.jumping.jump_height
			if Ap.jumping.update_direction:
				Ap.movement_settings.updateDirection()
				Ap.movement_settings.retroMovement(Ap.movement_settings.speed)
		elif snap != Vector3.ZERO:
			jump_count = 0
		Ap.player.move_and_slide_with_snap(gravity,snap,Vector3.UP)
