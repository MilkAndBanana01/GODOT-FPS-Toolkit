tool
extends Node

export var startingFov := 70.0

var currentHeight : float
var currentFOV : float

onready var camera = Camera.new()
onready var head = Spatial.new()
onready var wallCheck = RayCast.new()
onready var dashCheck = RayCast.new()
onready var cameraDashPos = Spatial.new()

onready var springArm = SpringArm.new()
onready var springArmPos = Spatial.new()
onready var checkDashPos = RayCast.new()

var testSpatial = MeshInstance.new()

var headExists : bool
var camExists : bool

func addCamera():
	testSpatial.mesh = CubeMesh.new()
	for i in AP.player.get_children():
		if i.name == "Head":
			head = i
			headExists = true
			for child in head.get_children():
				if child is Camera:
					camera = child
					camExists = true
#	if not headExists:
#		head.name = 'Head'
#		AP.player.call_deferred('add_child',head)
#		head.call_deferred('set_owner',AP.player)
#		head.translation.y = AP.movementNode.height
#		wallCheck.name = "wallCheck"
#		dashCheck.name = "dashCheck"
#		wallCheck.enabled = true
#		dashCheck.enabled = true
#		wallCheck.cast_to = Vector3(0,0,-1)
#
#		dashCheck.cast_to = Vector3(0,0,-AP.dashNode.distance)
#		head.call_deferred('add_child',dashCheck)
#		cameraDashPos.name = "cameraDashPos"
#		head.call_deferred('add_child',cameraDashPos)
#		cameraDashPos.translation = Vector3(0,0,-AP.dashNode.distance)
#
#		AP.player.call_deferred('add_child',wallCheck)
#		wallCheck.global_transform.origin = dashCheck.global_transform.origin
#
#		springArm.name = "SpringArm"
#		springArm.spring_length = -AP.dashNode.distance
#		springArm.shape = RayShape.new()
#		head.call_deferred('add_child',springArm)
#		springArm.call_deferred('add_child',springArmPos)
#		checkDashPos.name = "CheckDashPos"
#		checkDashPos.enabled = true
#		checkDashPos.cast_to = Vector3(0,AP.movementNode.height + 1,0)
#		springArmPos.call_deferred('add_child',checkDashPos)
#	if not camExists:
#		camera.name = 'Camera'
#		camera.current = get_node("Basic Settings").enabled
#		head.call_deferred('add_child',camera)
#		camera.call_deferred('set_owner',AP.player)
	
	camera.fov = startingFov

func _ready():
	if not Engine.editor_hint:
		addCamera()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	if not Engine.editor_hint:
		if AP.runNode.changeFOV:
			if Input.is_action_pressed('run'):
				currentFOV = 100 if not AP.runNode.customFOV > 0 else AP.runNode.customFOV
			else:
				currentFOV = startingFov
		camera.fov = lerp(camera.fov,clamp(currentFOV * clamp(AP.movementNode.get_node('Move').velocity.length(),0,1),startingFov,100 if not AP.runNode.customFOV > 0 else AP.runNode.customFOV),delta * AP.runNode.customFOVRate)
		if AP.crouchNode.heightConfiguration == 0:
			head.translation.y = currentHeight
		else:
			head.translation.y = lerp(head.translation.y,currentHeight,AP.crouchNode.heightInterpolation * delta)
		if Input.is_action_pressed('crouch') and (AP.runNode.allowRunningWhileCrouching or not Input.is_action_pressed('run'))\
		and (AP.player.is_on_floor() or (AP.crouchNode.allowMidAir and (AP.crouchNode.midAirConfiguration == 0 or AP.crouchNode.midAirConfiguration > 1))):
			currentHeight = AP.crouchNode.crouchHeight
		elif not AP.crouchNode.raycast.is_colliding():
			currentHeight = AP.movementNode.height
		springArmPos.rotation_degrees = Vector3.ZERO

func updateHeight(h):
	head.translation.y = h
