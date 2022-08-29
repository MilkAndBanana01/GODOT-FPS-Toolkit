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
		Ap.jumping.jump()
		Ap.climbing.climb()
		Ap.player.move_and_slide_with_snap(gravity,snap,Vector3.UP)
