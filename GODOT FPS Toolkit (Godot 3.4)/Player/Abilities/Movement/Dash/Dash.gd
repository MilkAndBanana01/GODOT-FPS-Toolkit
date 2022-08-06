extends Node

# Special thanks to NAD LABS for the interpolated dashing method!

export var enabled := true
export(int,"Instant","Interpolated") var dashConfiguration := 0
export(int,"Input-Based","Camera-Based") var dashInput := 0
export var invicibility := false
export var fallCancel := true
export var distance := 10
export var cooldown := 10

var input
onready var moveNode = get_parent().get_node("Move")

var timer = Timer.new()

var extraSpeed := Vector3()
var forward := true

func _ready() -> void:
	timer.one_shot = true
	timer.wait_time = cooldown
	timer.name = "DashTimer"
	AP.player.call_deferred('add_child',timer)

func _input(event: InputEvent) -> void:
	if dashInput == 0:
		input = Vector2(Input.get_action_strength('move_right') - Input.get_action_strength('move_left'),Input.get_action_strength('move_back') - Input.get_action_strength('move_forward'))
#	else:
#		input = Vector3( - AP.cameraNode.head.global_transform.origin).normalized()
	if Input.is_action_just_pressed("run") and timer.is_stopped()\
	and (invicibility or not AP.cameraNode.wallCheck.is_colliding()):
		if dashConfiguration == 0:
			if invicibility or (not invicibility and not AP.cameraNode.dashCheck.is_colliding()):
				if dashInput == 0:
					AP.player.translate(Vector3(input.x * distance,0,input.y * distance))
				else:
					AP.player.global_transform.origin = AP.cameraNode.cameraDashPos.global_transform.origin
				timer.start()
			else:
				if AP.cameraNode.dashCheck.is_colliding():
					var newPos = AP.cameraNode.dashCheck.get_collision_point()
					AP.player.global_transform.origin = Vector3(newPos.x,AP.player.global_transform.origin.y,newPos.z)
					timer.start()
		else:
			extraSpeed = (AP.player.transform.basis * Vector3(input.x, 0, input.y)).normalized() * distance
			timer.start()

func _physics_process(_delta: float) -> void:
	AP.moveNode.velocity += extraSpeed
	extraSpeed = lerp(extraSpeed,Vector3.ZERO,0.1)
	if fallCancel and extraSpeed.length() > 1:
		AP.gravityNode.gravityVec = Vector3.ZERO
