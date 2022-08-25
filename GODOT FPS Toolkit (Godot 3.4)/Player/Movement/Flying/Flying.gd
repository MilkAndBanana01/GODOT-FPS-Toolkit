extends Node

export var enabled := false
export(int,FLAGS,"Godot","Minecraft-style","Camera") var inputs := 2
export var custom_speed := 0
export var custom_acceleration := 0
#export var scroll_speed_change := true
onready var minecraft_style : bool = (Ap.flying.inputs > 1 and Ap.flying.inputs < 4) or (Ap.flying.inputs > 5 and Ap.flying.inputs < 8)
onready var godot_style : bool = Ap.flying.inputs > 0 and Ap.flying.inputs % 2 != 0
onready var camera_input : bool = Ap.flying.inputs > 3

onready var timer = Timer.new()
onready var gravity_enabled = Ap.gravity.enabled
var flying := false
var attempt_flying := false
onready var speed = custom_speed if custom_speed > 0 else Ap.movement_settings.speed
onready var acceleration = custom_acceleration if custom_acceleration > 0 else Ap.movement_settings.acceleration
var flying_direction : float
var snap :Vector3

func _enter_tree() -> void:
	Ap.flying = self

func _ready() -> void:
	timer.one_shot = true
	timer.name = "Fly Input Buffer"
	add_child(timer)
	timer.connect("timeout",self,"removeInput")


func _input(event: InputEvent) -> void:
	if Ap.player.is_on_floor():
		if godot_style:
			if Input.is_key_pressed(KEY_E):
				snap = Vector3.ZERO
				Ap.gravity.enabled = false
				flying = true
			if Input.is_key_pressed(KEY_Q):
				Ap.gravity.enabled = true
				flying = false
	if Input.is_action_just_pressed("jump") and minecraft_style:
			if attempt_flying:
				timer.stop()
				Ap.gravity.enabled = false
				if flying:
					Ap.gravity.enabled = true
					flying = false
				else:
					flying = true
				attempt_flying = false
			else:
				attempt_flying = true
				timer.start(0.5)


func _physics_process(delta: float) -> void:
	if enabled:
		if gravity_enabled:
			if flying:
				fly()
				if Ap.player.is_on_floor():
					Ap.gravity.enabled = true
					flying = false
		else:
			fly()

func fly():
	print(Ap.head.rotation)
	flying_direction = 0
	if camera_input:
		flying_direction = clamp(Ap.head.rotation.x,-1.5,1.5) * Input.get_action_strength("move_forward")
	if godot_style and (Input.is_key_pressed(KEY_E) or Input.is_key_pressed(KEY_Q)):
		flying_direction = (float(Input.is_key_pressed(KEY_E)) - float(Input.is_key_pressed(KEY_Q)))
	if minecraft_style and (Input.get_action_strength("jump") or Input.is_key_pressed(KEY_SHIFT)):
		flying_direction = (Input.get_action_strength("jump") - float(Input.is_key_pressed(KEY_SHIFT)))
	snap = -Ap.player.get_floor_normal() if Ap.player.is_on_floor() and not flying else Vector3.ZERO
	Ap.player.move_and_slide_with_snap(Vector3(0,flying_direction * speed,0),snap,Vector3.UP)


func removeInput():
	attempt_flying = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
