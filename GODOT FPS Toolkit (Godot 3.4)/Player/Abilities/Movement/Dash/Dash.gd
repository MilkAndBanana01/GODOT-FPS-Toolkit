extends Node

# Special thanks to NAD LABS for the interpolated dashing method!

export var enabled := true
export(int,"Instant","Interpolated") var dashConfiguration := 0
export var distance := 10
export var cooldown := 10

var player
onready var moveNode = get_parent().get_node("Move")

var timer = Timer.new()

var extraSpeed := Vector3()
var forward := true

func _ready() -> void:
	player = owner.get_parent()
	timer.one_shot = true
	timer.wait_time = cooldown
	player.call_deferred('add_child',timer)
	timer.connect('timeout',self,'refreshDash')

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("move_forward"):
		forward = true
	if Input.is_action_pressed("move_back"):
		forward = false
	print(timer.is_stopped())
	if Input.is_action_just_pressed("run") and timer.is_stopped():
		if dashConfiguration == 0:
			if forward:
				player.translate(Vector3(0,0,-distance))
			else:
				player.translate(Vector3(0,0,distance))
		timer.start()

func _physics_process(delta: float) -> void:
	moveNode.velocity += extraSpeed
	extraSpeed = lerp(extraSpeed,Vector3.ZERO,delta)
