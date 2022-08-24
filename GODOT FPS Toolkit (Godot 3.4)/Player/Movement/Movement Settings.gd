extends Node

export var enabled := true
export(int,"Retro","Modern") var style := 0
export var movement_speed := 10.0
export var movement_acceleration := 1.0
export var enable_friction := false
export var friction_rate := 1.0

var input : Vector2
var direction : Vector3
var velocity : Vector3
var snap : Vector3

func _enter_tree() -> void:
	Ap.movement_settings = self


func update_direction():
	input = Input.get_vector("move_left","move_right","move_forward","move_back")
	direction = (Ap.player.transform.basis * Vector3(input.x, 0, input.y)).normalized()
	retroMovement(movement_speed)

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
	if enabled:
		movement_speed = movement_speed + Ap.mid_air_settings.custom_air_speed if Ap.mid_air_settings.enabled else movement_speed
		movement_acceleration = movement_acceleration + Ap.mid_air_settings.custom_air_acceleration if Ap.mid_air_settings.enabled else movement_acceleration
		snap = -Ap.player.get_floor_normal() if Ap.player.is_on_floor() else Vector3.ZERO
		if Ap.player.is_on_floor() or not Ap.gravity.enable or Ap.mid_air_settings.enable_air_movement:
			update_direction()
			retroMovement(movement_speed) if style == 0 else modernMovement(movement_speed,movement_acceleration,delta)
		if Ap.player.is_on_floor() or Ap.mid_air_settings.enable_air_momentum or Ap.mid_air_settings.enable_air_movement:
			Ap.player.move_and_slide_with_snap(velocity,snap,Vector3.UP)