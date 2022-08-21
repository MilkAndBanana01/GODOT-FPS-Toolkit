tool
extends Node

var gravityVec : Vector3
var snapVec : Vector3
var jumping = false
var jumpCount : int


onready var grav_enabled = get_node("Gravity Settings").enabled
onready var grav_style = get_node("Gravity Settings").gravityStyle
onready var grav_gravityRate = get_node("Gravity Settings").gravityRate
onready var grav_enableLimit = get_node("Gravity Settings").enableLimit
onready var grav_gravityLimit = get_node("Gravity Settings").gravityLimit
onready var jump_enabled = get_node("Jump Settings").enabled
onready var jump_height = get_node("Jump Settings").jumpHeight
onready var jump_limit = get_node("Jump Settings").jumpLimit
onready var jump_updateDirection = get_node("Jump Settings").updateDirection

#func _ready() -> void:
#	if not Engine.editor_hint:
#		var height = get_parent().height
#		raycast.translation.y = ((-height + 1)/2)
#		raycast.cast_to = Vector3(0,-1.01,0)
#		raycast.enabled = true
#		AP.player.call_deferred('add_child',raycast)

#func updateHeight(h):
#	raycast.translation.y = ((-h + 1)/2)

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint() == false and grav_enabled:
		if AP.movementNode.checkFloor.is_colliding() and not Input.is_action_pressed('jump'):
			jumpCount = 0
		if AP.movementNode.checkFloor.is_colliding():
			gravityVec = Vector3.ZERO
			snapVec = -AP.player.get_floor_normal()
		if Input.is_action_just_pressed('jump') and jumpCount < jump_limit:
			snapVec = Vector3.ZERO
			gravityVec = jump_height * Vector3.UP
			jumpCount += 1
		else:
			snapVec = Vector3.DOWN
			if grav_style == 1:
				gravityVec += Vector3.DOWN * grav_gravityRate * delta
			else:
				gravityVec = Vector3.DOWN * grav_gravityRate
		AP.player.move_and_slide_with_snap(gravityVec,snapVec,Vector3.UP)
