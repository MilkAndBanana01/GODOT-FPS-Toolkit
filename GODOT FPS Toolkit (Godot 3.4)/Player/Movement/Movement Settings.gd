extends Node

export(int,"Retro","Modern") var style := 0
export var movement_speed := 10.0
export var movement_acceleration := 1.0
export var enable_friction := false
export var friction_rate := 1.0

var input : Vector2
var direction : Vector3
var velocity : Vector3

func retroMovement(s):
	velocity = Vector3.ZERO
	velocity.x = direction.x * s
	velocity.z = direction.z * s
func modernMovement(s,a,d):
	velocity = velocity.linear_interpolate(Vector3(direction.x,0,direction.z) * s, d * a)
	applyFriction(friction_rate,d)
func applyFriction(f,d):
	if input == Vector2.ZERO and enable_friction:
		velocity = velocity.linear_interpolate(Vector3.ZERO, d * f)

func _physics_process(delta: float) -> void:
	input = Input.get_vector("move_left","move_right","move_forward","move_back")
	direction = (Ap.player.transform.basis * Vector3(input.x, 0, input.y)).normalized()
	retroMovement(movement_speed) if style == 0 else modernMovement(movement_speed,movement_acceleration,delta)
	Ap.player.move_and_slide(velocity,Vector3.UP)
