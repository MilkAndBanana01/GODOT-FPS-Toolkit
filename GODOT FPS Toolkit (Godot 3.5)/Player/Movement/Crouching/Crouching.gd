extends Node

export var enabled := true
export(int,"Instant","Interpolated") var shift_style := 0
export var standing_height := 0.0
export var crouching_height := 0.0
export var crouching_acceleration := 0.0
export var speed := 0.0
export var acceleration := 0.0


func _ready() -> void:
	Ap.player.crouch_transition = shift_style
	Ap.player.height = standing_height if standing_height > 0 else Ap.player.height
	Ap.player.crouch_height = crouching_height if crouching_height > 0 else Ap.player.crouch_height
	Ap.player.crouch_interpolation = crouching_acceleration if crouching_acceleration > 0 else Ap.player.crouch_interpolation


func _physics_process(delta: float) -> void:
	if enabled and not Input.is_action_pressed("run"):
		Ap.player.load_base_col.visible = !Input.is_action_pressed("crouch")
		if Ap.player.is_on_floor() and Input.is_action_pressed("crouch"):
			Ap.movement_settings.current_speed =- speed if speed > 0 else Ap.movement_settings.current_speed / 2
			Ap.movement_settings.current_acceleration = acceleration if acceleration > 0 else Ap.movement_settings.current_acceleration
