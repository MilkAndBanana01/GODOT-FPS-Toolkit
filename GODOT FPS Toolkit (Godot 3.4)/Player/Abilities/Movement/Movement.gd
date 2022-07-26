tool
extends Node

var inputs := ["move_left","move_right","move_back","move_forward","jump","sprint","crouch","interact"]
var keyCodes := [KEY_A,KEY_D,KEY_S,KEY_W,KEY_SPACE,KEY_SHIFT,KEY_CONTROL,KEY_E]

var player
var camera = Camera.new()
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
	var pos := 0
	for i in inputs:
		if InputMap.has_action(i):
			addingEvent(pos,i)
		else:
			InputMap.add_action(i)
			addingEvent(pos,i)
		pos += 1
	addCollision()

func addCollision():
	player = get_parent()
	if player.get_node_or_null('Collision') == null:
		collision.name = "Collision"
		capsule.radius = 0.5
		collision.set_shape(capsule)
		collision.rotate_x(deg2rad(90))
		player.call_deferred('add_child',collision)
