tool
extends Node

var player

var movementNode
var gravityNode
var jumpNode
var crouchNode
var runNode

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
	if get_parent() is KinematicBody:
		player = get_parent()
	else:
		player = owner.get_parent()
	movementNode = get_parent()
	gravityNode = player.get_node_or_null('Movement/Gravity')
	jumpNode = player.get_node_or_null('Movement/Gravity/Jump Settings')
	crouchNode = player.get_node_or_null('Movement/Crouch')
	runNode = player.get_node_or_null('Movement/Run')
	currentSpeed = speed

func movePlayer():
	input = Vector2(Input.get_action_strength('move_right') - Input.get_action_strength('move_left'),Input.get_action_strength('move_back') - Input.get_action_strength('move_forward'))
	direction = (player.transform.basis * Vector3(input.x, 0, input.y)).normalized()
func retroMovement(s):
	velocity = Vector3.ZERO
	velocity.x = direction.x * s
	velocity.z = direction.z * s
func modernMovement(s,a,d):
	velocity = velocity.linear_interpolate(Vector3(direction.x,0,direction.z) * s, d * a)
func applyFriction(f,d):
	velocity = velocity.linear_interpolate(Vector3.ZERO, d * f)

func _input(_event: InputEvent) -> void:
	if jumpNode != null:
		if jumpNode.updateDirection:
			if Input.is_action_just_pressed('jump') and gravityNode.jumpCount < jumpNode.jumpLimit:
				movePlayer()
				retroMovement(speed + airMomentumSpeed)
	if Input.is_action_pressed('crouch') and player.is_on_floor() \
	and (runNode.allowRunningWhileCrouching or not Input.is_action_pressed('run')):
		crouchNode.collision.disabled = false
		movementNode.collision.disabled = true
	else:
		crouchNode.collision.disabled = true
		movementNode.collision.disabled = false


func _physics_process(delta: float) -> void:
	if not Engine.editor_hint:
		currentSpeed = speed - (int(crouchNode.enabled) * (Input.get_action_strength('crouch') * crouchNode.crouchSpeed)) + (int(runNode.enabled) * (Input.get_action_strength('run') * runNode.runningSpeed))
		if player.is_on_floor():
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
					modernMovement((speed + airMomentumSpeed),acceleration + airMomentumAcc,delta)
				else:
					retroMovement(speed + airMomentumSpeed)
			elif airMovementEnabled:
				movePlayer()
				if movementStyle == 1:
					modernMovement((speed + airMovementSpeed),acceleration + airMovementAcc,delta)
				else:
					retroMovement(speed + airMovementSpeed)
			else:
				velocity = Vector3.ZERO
		player.move_and_slide(velocity,Vector3.UP)
