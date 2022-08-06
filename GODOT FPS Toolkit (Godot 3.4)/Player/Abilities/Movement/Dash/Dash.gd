extends Node

# Special thanks to NAD LABS for the interpolated dashing method!

export var enabled := true
export(int,"Instant","Interpolated") var dashConfiguration := 0
export var invicibility := false
export var distance := 10
export var cooldown := 10

var input := Vector2()
onready var moveNode = get_parent().get_node("Move")

var timer = Timer.new()

var extraSpeed := Vector3()
var forward := true

func _ready() -> void:
	timer.one_shot = true
	timer.wait_time = cooldown
	AP.player.call_deferred('add_child',timer)

func _input(event: InputEvent) -> void:
	input = Vector2(Input.get_action_strength('move_right') - Input.get_action_strength('move_left'),Input.get_action_strength('move_back') - Input.get_action_strength('move_forward'))
	if Input.is_action_just_pressed("run") and timer.is_stopped()\
	and (invicibility or not AP.cameraNode.wallCheck.is_colliding()):
		if dashConfiguration == 0:
			if invicibility or (not invicibility and not AP.cameraNode.dashCheck.is_colliding()):
				AP.player.translate(Vector3(input.x * distance,0,input.y * distance))
				timer.start()
			else:
				if AP.cameraNode.dashCheck.is_colliding():
					var newPos = AP.cameraNode.dashCheck.get_collision_point()
					AP.player.global_transform.origin = Vector3(newPos.x,AP.player.global_transform.origin.y,newPos.z)
					timer.start()
		else:
			extraSpeed = (AP.player.transform.basis * Vector3(input.x, 0, input.y)).normalized() * distance
			AP.gravityNode.gravityVec = Vector3.ZERO
			timer.start()

func _physics_process(_delta: float) -> void:
	AP.moveNode.velocity += extraSpeed
	extraSpeed = lerp(extraSpeed,Vector3.ZERO,0.1)
