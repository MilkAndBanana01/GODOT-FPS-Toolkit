extends Node

export var enabled := true
export var speed := 10.0
export var acceleration := 1
export var affect_FOV := true
export var custom_FOV := 0
export var affect_tilt := true
export var custom_tilt := 0.0
onready var running_speed = Ap.walking.speed if Ap.walking.speed > 0 else speed/2

func _enter_tree() -> void:
	Ap.running = self

func _physics_process(delta: float) -> void:
	if Ap.running.enabled and Input.is_action_pressed("run") and Ap.player.is_on_floor()\
	or Ap.flying.enabled and not Ap.player.is_on_floor() and Ap.flying.running_input != 3 and \
	((Input.is_action_pressed("run") and (Ap.flying.running_input == 0 and not Ap.flying.minecraft_style or Ap.flying.running_input == 2)) or \
	(Input.is_key_pressed(KEY_CONTROL) and (Ap.flying.running_input == 0 and Ap.flying.minecraft_style or Ap.flying.running_input == 1))):
		Ap.movement_settings.current_speed += speed
		Ap.movement_settings.current_acceleration = Ap.running.acceleration if Ap.running.acceleration > 0 else acceleration
