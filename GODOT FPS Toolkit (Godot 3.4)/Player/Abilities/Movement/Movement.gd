tool
extends Node

signal updateHeight

export(float,0.1,999) var height = 1.0 setget updateHeight

var inputs := ["move_left","move_right","move_back","move_forward","jump","run","crouch","interact"]
var keyCodes := [KEY_A,KEY_D,KEY_S,KEY_W,KEY_SPACE,KEY_SHIFT,KEY_CONTROL,KEY_E]

var player
var cameraNode
var gravityNode

var collision = CollisionShape.new()
var capsule = CapsuleShape.new()

func addingEvent(pos,i):
	var inputEvent = InputEventKey.new()
	inputEvent.scancode = keyCodes[pos]
	if InputMap.action_has_event(i,inputEvent):
		pass
	else:
		InputMap.action_add_event(i,inputEvent)

func _ready() -> void:
	player = get_parent()
	var pos := 0
	for i in inputs:
		if InputMap.has_action(i):
			addingEvent(pos,i)
		else:
			InputMap.add_action(i)
			addingEvent(pos,i)
		pos += 1
	cameraNode = player.get_node('Camera')
	gravityNode = get_node('Gravity')
	connect('updateHeight',cameraNode,'updateHeight')
	connect('updateHeight',gravityNode,'updateHeight')
	addCollision()

func addCollision():
	if player.get_node_or_null('Collision') == null:
		collision.name = "Collision"
		capsule.height = height
		capsule.radius = 0.5
		collision.set_shape(capsule)
		collision.rotate_x(deg2rad(90))
		player.call_deferred('add_child',collision)

func updateHeight(h):
	height = h
	emit_signal("updateHeight",h)
	capsule.height = height
