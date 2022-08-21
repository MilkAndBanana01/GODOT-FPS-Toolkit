tool
extends Node

var currentSpeed
var input : Vector2
var direction : Vector3
var velocity : Vector3
var snapVec : Vector3

onready var movementEnabled = get_node("Movement Settings").enabled
onready var movementStyle = get_node("Movement Settings").movementStyle
onready var speed = get_node("Movement Settings").speed
onready var acceleration = get_node("Movement Settings").acceleration
onready var frictionEnabled = get_node("Movement Settings").enableFriction
onready var friction = get_node("Movement Settings").friction
onready var airMomentumEnabled = get_node("Air Momentum Settings").enabled
onready var airMomentumAcc = get_node("Air Momentum Settings").acceleration
onready var airMomentumSpeed = get_node("Air Momentum Settings").customSpeed
onready var airMovementEnabled = get_node("Air Movement Settings").enabled
onready var airMovementSpeed = get_node("Air Movement Settings").customSpeed
onready var airMovementAcc = get_node("Air Movement Settings").customAcceleration

func _ready() -> void:
	currentSpeed = speed

func movePlayer():
	input = Vector2(Input.get_action_strength('move_right') - Input.get_action_strength('move_left'),Input.get_action_strength('move_back') - Input.get_action_strength('move_forward'))
	direction = (AP.player.transform.basis * Vector3(input.x, 0, input.y)).normalized()
func retroMovement(s):
	velocity = Vector3.ZERO
	velocity.x = direction.x * s
	velocity.z = direction.z * s
func modernMovement(s,a,d):
	velocity = velocity.linear_interpolate(Vector3(direction.x,0,direction.z) * s, d * a)
func applyFriction(f,d):
	velocity = velocity.linear_interpolate(Vector3.ZERO, d * f)

func _input(_event: InputEvent) -> void:
	if is_instance_valid(AP.jumpNode):
		if AP.jumpNode.updateDirection:
			if Input.is_action_just_pressed('jump') and AP.gravityNode.jumpCount < AP.jumpNode.jumpLimit:
				movePlayer()
				retroMovement(speed + airMomentumSpeed)

func _physics_process(delta: float) -> void:
	if not Engine.editor_hint:
		currentSpeed = speed - \
		(int(AP.crouchNode.enabled) * (int(AP.player.is_on_floor() or (clamp(AP.crouchNode.midAirConfiguration,0,1)) * int(AP.crouchNode.allowMidAir))) * (clamp((Input.get_action_strength('crouch') + int(AP.crouchNode.raycast.is_colliding())),0,1) * AP.crouchNode.crouchSpeed)) + \
		(int(AP.runNode.enabled) * int(AP.player.is_on_floor() or AP.runNode.allowMidAir) * (Input.get_action_strength('run') * AP.runNode.runningSpeed))
		if AP.player.is_on_floor():
			movePlayer()
			if movementStyle == 0:
				retroMovement(currentSpeed)
			else:
				modernMovement(currentSpeed,acceleration,delta)
				if input == Vector2.ZERO and frictionEnabled:
					applyFriction(friction,delta)
		else:
			if airMomentumEnabled:
				if movementStyle == 1:
					modernMovement((currentSpeed + airMomentumSpeed),acceleration + airMomentumAcc,delta)
				else:
					retroMovement(currentSpeed + airMomentumSpeed)
			elif airMovementEnabled:
				movePlayer()
				if movementStyle == 1:
					modernMovement((currentSpeed + airMovementSpeed),acceleration + airMovementAcc,delta)
				else:
					retroMovement(currentSpeed + airMovementSpeed)
			else:
				velocity = Vector3.ZERO
		AP.player.move_and_slide(velocity,Vector3.UP)
