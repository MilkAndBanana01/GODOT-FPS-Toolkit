extends Node

export var enabled := false
export(int,"Retro","Modern") var style := 0
export(int,FLAGS,"Godot","Minecraft-style","Camera") var inputs := 2
export var custom_speed := 0.0
export var custom_acceleration := 0.0
#export var scroll_speed_change := true
export var speed_rate := 1
export var speed_limit := 0
onready var minecraft_style : bool = (Ap.flying.inputs > 1 and Ap.flying.inputs < 4) or (Ap.flying.inputs > 5 and Ap.flying.inputs < 8)
onready var godot_style : bool = Ap.flying.inputs > 0 and Ap.flying.inputs % 2 != 0
onready var camera_input : bool = Ap.flying.inputs > 3

onready var timer = Timer.new()
onready var gravity_enabled = Ap.gravity.enabled
var is_flying := false
var attempt_flying := false
onready var speed = custom_speed if custom_speed > 0 else Ap.movement_settings.speed
onready var acceleration = custom_acceleration if custom_acceleration > 0 else Ap.movement_settings.acceleration
var flying_direction : float
var snap :Vector3
var flying_velocity : Vector3


func retro():
	flying_velocity = Vector3.ZERO
	flying_velocity.y = flying_direction * speed


func modern(delta):
	flying_velocity = flying_velocity.linear_interpolate(Vector3(0,flying_direction * speed,0) * speed, delta * acceleration)
	if flying_direction == 0:
		flying_velocity = flying_velocity.linear_interpolate(Vector3.ZERO, delta * acceleration)


func fly(delta):
	flying_direction = 0
	if camera_input:
		flying_direction = clamp(Ap.head.rotation.x,-1.5,1.5) * Input.get_action_strength("move_forward")
	if godot_style and (Input.is_key_pressed(KEY_E) or Input.is_key_pressed(KEY_Q)):
		flying_direction = (float(Input.is_key_pressed(KEY_E)) - float(Input.is_key_pressed(KEY_Q)))
	if minecraft_style and (Input.get_action_strength("jump") or Input.is_key_pressed(KEY_SHIFT)):
		flying_direction = (Input.get_action_strength("jump") - float(Input.is_key_pressed(KEY_SHIFT)))
	snap = -Ap.player.get_floor_normal() if Ap.player.is_on_floor() and not is_flying else Vector3.ZERO
	retro() if style == 0 else modern(delta)
	Ap.player.move_and_slide_with_snap(flying_velocity,snap,Vector3.UP)


func removeInput():
	attempt_flying = false


func _enter_tree() -> void:
	Ap.flying = self


func _ready() -> void:
	speed_limit = speed_limit if speed_limit > 0 else Ap.movement_settings.speed + Ap.movement_settings.speed/2
	timer.one_shot = true
	timer.name = "Fly Input Buffer"
	add_child(timer)
	timer.connect("timeout",self,"removeInput")


func _input(event: InputEvent) -> void:
	if godot_style:
		if Input.is_key_pressed(KEY_E):
			snap = Vector3.ZERO
			Ap.gravity.enabled = false
			is_flying = true
		if Input.is_key_pressed(KEY_Q) and Ap.player.is_on_floor():
			Ap.gravity.enabled = true
			is_flying = false
	if Input.is_action_just_pressed("jump") and minecraft_style:
			if attempt_flying:
				timer.stop()
				Ap.gravity.enabled = false
				if is_flying:
					Ap.gravity.enabled = true
					is_flying = false
				else:
					is_flying = true
				attempt_flying = false
			else:
				attempt_flying = true
				timer.start(0.5)
	if is_flying:
		if Input.is_mouse_button_pressed(BUTTON_WHEEL_UP):
			speed += speed_rate
		if Input.is_mouse_button_pressed(BUTTON_WHEEL_DOWN):
			speed -= speed_rate
	speed = clamp(speed,0,speed_limit)
	print(speed)
func _physics_process(delta: float) -> void:
	if enabled:
		if is_flying == false:
			flying_velocity = Vector3.ZERO
		if gravity_enabled:
			if is_flying:
				fly(delta)
				if Ap.player.is_on_floor():
					Ap.gravity.enabled = true
					is_flying = false
		else:
			fly(delta)
