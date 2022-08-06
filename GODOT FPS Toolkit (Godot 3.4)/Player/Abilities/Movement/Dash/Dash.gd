extends Node

# Special thanks to NAD LABS for the interpolated dashing method!

export var enabled := true
export(int,"Instant","Interpolated") var dashConfiguration := 0
export var invicibility := false
export var distance := 10
export var cooldown := 10

var player
var cameraNode
var input := Vector2()
onready var moveNode = get_parent().get_node("Move")

var timer = Timer.new()

var extraSpeed := Vector3()
var forward := true

func _ready() -> void:
	player = owner.get_parent()
	timer.one_shot = true
	timer.wait_time = cooldown
	cameraNode = player.get_node("Camera")
	player.call_deferred('add_child',timer)
	timer.connect('timeout',self,'refreshDash')

func _input(event: InputEvent) -> void:
	input = Vector2(Input.get_action_strength('move_right') - Input.get_action_strength('move_left'),Input.get_action_strength('move_back') - Input.get_action_strength('move_forward'))
	if Input.is_action_just_pressed("run") and timer.is_stopped()\
	and (not cameraNode.wallCheck.is_colliding() or invicibility):
		if dashConfiguration == 0:
			player.translate(Vector3(input.x * distance,0,input.y * distance))
			print('dash')
		timer.start()

func _physics_process(delta: float) -> void:
	moveNode.velocity += extraSpeed
	extraSpeed = lerp(extraSpeed,Vector3.ZERO,delta)
