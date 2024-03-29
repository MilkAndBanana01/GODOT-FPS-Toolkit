tool
extends Node

signal updateHeight

export(float,0.1,999) var height = 1.0

var inputs := ["move_left","move_right","move_back","move_forward","jump","run","crouch","interact"]
var keyCodes := [KEY_A,KEY_D,KEY_S,KEY_W,KEY_SPACE,KEY_SHIFT,KEY_CONTROL,KEY_E]

var collision = CollisionShape.new()
var capsule = CapsuleShape.new()

var baseCol
var crouchCol
var checkCeiling
var checkFloor

func addingEvent(pos,i):
	var inputEvent = InputEventKey.new()
	inputEvent.scancode = keyCodes[pos]
	if InputMap.action_has_event(i,inputEvent):
		pass
	else:
		InputMap.action_add_event(i,inputEvent)

func _ready() -> void:
	var pos := 0
	for i in inputs:
		if InputMap.has_action(i):
			addingEvent(pos,i)
		else:
			InputMap.add_action(i)
			addingEvent(pos,i)
		pos += 1
	addCollision()
	print(baseCol)
	print(crouchCol)
	print(checkCeiling)
	print(checkFloor)

func addCollision():
	var tallestHeight = 0
	for i in AP.player.get_children():
		if i is CollisionShape:
			if i.shape.height > tallestHeight:
				baseCol = i
				tallestHeight = i.shape.height
			else:
				crouchCol = i
		if i is RayCast:
			checkFloor = i
	for i in crouchCol.get_children():
		if i is RayCast:
			checkCeiling = i

	baseCol.shape.height = height
	crouchCol.shape.height = AP.crouchNode.crouchHeight
	crouchCol.translation = Vector3(0,-((baseCol.shape.height - crouchCol.shape.height) / 2),0)
	checkCeiling.cast_to = Vector3(0,2 + ((baseCol.shape.height - crouchCol.shape.height) / 2),0)
	checkFloor.cast_to = Vector3(0,0.5 + (baseCol.shape.height / 2),0)

#	if AP.player.get_node_or_null('Collision') == null:
#		collision.name = "Collision"
#		capsule.height = height
#		capsule.radius = 0.5
#		collision.set_shape(capsule)
#		collision.rotate_x(deg2rad(90))
#		AP.player.call_deferred('add_child',collision)
