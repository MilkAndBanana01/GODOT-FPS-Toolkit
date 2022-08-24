extends Node

export var enable := true
export var gravity_rate := 1.0

onready var check_floor = Ap.player.get_node("Check Floor")

var gravity : Vector3
var snap : Vector3
var momentum : Vector3
var jump_count := 0


func _ready() -> void:
	Ap.gravity = self


func _physics_process(delta: float) -> void:
	if enable:
		gravity = (gravity + (Vector3.DOWN * gravity_rate)) if snap == Vector3.ZERO else Vector3.ZERO
		snap = -check_floor.get_collision_normal() if check_floor.is_colliding() else Vector3.ZERO
		if Input.is_action_just_pressed("jump") and jump_count < Ap.jumping.maximum_jumps:
			jump_count += 1
			snap = Vector3.ZERO
			gravity = Vector3.UP * Ap.jumping.jump_height
			if Ap.jumping.update_direction:
				Ap.movement_settings.update_direction()
		elif snap != Vector3.ZERO:
			jump_count = 0
		Ap.player.move_and_slide_with_snap(gravity,snap,Vector3.UP)
