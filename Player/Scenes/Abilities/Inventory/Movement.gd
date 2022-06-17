@tool
extends Node

var props : Array
var walkingEnabled : bool = true

#@export_enum("Retro - No Momentum", "Modern - Momentum") var movementStyle: int
#@export var speed : float
#@export var acceleration : float
#@export var gravity = 9.8
#@export var enableJumping = true
#@export var jumpHeigth : int

var player
var raycast

var jumped := false
var inputMove: Vector3 = Vector3()
var gravityLocal: Vector3 = Vector3()
var snapVector: Vector3 = Vector3()


func _get(property):
	if property == 'walking/enabled': return walkingEnabled

func _set(property, value) -> bool:
	if property == 'walking/enabled': 
		walkingEnabled = value
		notify_property_list_changed()
	return true

func _get_property_list() -> Array:
	props = []
	props.append(
		{
			'name': 'Movement Settings',
			'type': TYPE_NIL,
			'usage': PROPERTY_USAGE_CATEGORY
		}
	)
	props.append(
		{
			'name': 'basic/walking/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'basic/gravity/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'basic/running/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'basic/jumping/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'basic/crouching/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'basic/grabbing & throwing/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'advanced/sliding/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'advanced/wall abilities/climbing/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'advanced/wall abilities/jumping/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'advanced/wall abilities/sliding/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'advanced/dashing/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'advanced/rolling/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'advanced/leaning/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'advanced/grappling/enabled',
			'type': TYPE_BOOL
		}
	)
	return props

#func _ready() -> void:
#	player = get_parent()
#	raycast = player.get_node("RayCast")
#
#func _physics_process(delta: float) -> void:
#	if movementStyle == 0:
#		inputMove = get_input_direction() * speed
#	else:
#		inputMove = inputMove.lerp(get_input_direction() * speed,acceleration * delta)
#	if not raycast.is_colliding():
#		gravityLocal += gravity * Vector3.DOWN * delta
#	else:
#		gravityLocal = Vector3.ZERO
#
#	snapVector = Vector3.DOWN
#	if raycast.is_colliding():
#		snapVector = -raycast.get_collision_normal()
#
#	if Input.is_action_just_pressed("jump") and raycast.is_colliding() and enableJumping:
#		snapVector = Vector3.ZERO
#		gravityLocal = Vector3.UP * jumpHeigth
#		jumped = true
#
#	player.move_and_slide_with_snap(inputMove + gravityLocal,snapVector,Vector3.UP)
#
#func get_input_direction() -> Vector3:
#	var z:float = (
#		Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
#	)
#	var x:float = (
#		Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
#	)
#	return player.transform.basis.xform(Vector3(x,0,z)).normalized()
