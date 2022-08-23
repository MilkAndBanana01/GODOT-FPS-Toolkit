extends Node

export var gravity_enabled := true
export var gravity_rate := 1.0
export var air_momentum := true
export var custom_air_speed := 0.0
export var custom_air_acceleration := 0.0

onready var check_floor = Ap.player.get_node("Check Floor")

var gravity : Vector3
var snap : Vector3

func _ready() -> void:
	Ap.gravity = self

func _physics_process(delta: float) -> void:
	print(snap)
	gravity = (gravity + (Vector3.DOWN * gravity_rate)) if snap == Vector3.ZERO else Vector3.ZERO
	snap = -check_floor.get_collision_normal() if check_floor.is_colliding() else Vector3.ZERO
	if Input.is_action_just_pressed("jump"):
		snap = Vector3.ZERO
		gravity = Vector3.UP * Ap.jumping.jump_height
	Ap.player.move_and_slide_with_snap(gravity,snap,Vector3.UP)
