tool
extends Node

var player

var input : Vector2
var direction : Vector3
var velocity : Vector3
var snapVec : Vector3
var gravityVec : Vector3

var movementEnabled : bool
var movementStyle : int
var speed : int
var acceleration : float
var frictionEnabled : bool
var friction : float

var properties = {
	{
		"property": 'Movement Settings',
		"type": 'category',
		"default": true,
		"enabler": 'enabled',
		"values": ['apple','banana','egg'],
		""
	}
}

func _get(property: String):
	if property == "enabled" : return movementEnabled
	if property == "movement style" : return movementStyle
	if property == "speed" : return speed
	if property == "acceleration" : return acceleration
	if property == "enable friction" : return frictionEnabled
	if property == 'friction' : return friction
func _set(property: String, value) -> bool:
	if property == 'enabled': 
		movementEnabled = value
		property_list_changed_notify()
	if property == 'movement style': 
		movementStyle = value
		property_list_changed_notify()
	if property == 'enable friction': 
		frictionEnabled = value
		property_list_changed_notify()
	if property == 'speed':
		value = clamp(value,0,INF)
		speed = value
	if property == 'acceleration':
		value = clamp(value,0,INF)
		acceleration = value
	if property == 'friction':
		value = clamp(value,0,INF)
		friction = value
	return true
func _get_property_list() -> Array:
	var props = []
	props.append(
		{
			'name': 'Movement Settings',
			'type': TYPE_NIL,
			'usage': PROPERTY_USAGE_CATEGORY
		}
	)
	props.append(
		{
			'name': 'enabled',
			'type': TYPE_BOOL
		}
	)
	if movementEnabled:
		props.append(
			{
				"name":"movement style", 
				"type":TYPE_INT, 
				"hint":3,
				"hint_string":"Retro - No Momentum,Modern - Momentum", 
			}
		)
		props.append(
			{
				'name': 'speed',
				'type': TYPE_INT
			}
		)
		if movementStyle == 1:
			props.append(
				{
					'name': 'acceleration',
					'type': TYPE_REAL
				}
			)
			props.append(
				{
					'name': 'enable friction',
					'type': TYPE_BOOL
				}
			)
			if frictionEnabled:
				props.append(
					{
						'name': 'friction',
						'type': TYPE_REAL
					}
				)
	return props

func _ready() -> void:
	if get_parent() is KinematicBody:
		player = get_parent()
	else:
		player = owner.get_parent()

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint() == false:
		input = Vector2(Input.get_action_strength('move_right') - Input.get_action_strength('move_left'),Input.get_action_strength('move_back') - Input.get_action_strength('move_forward'))
		direction = (player.transform.basis * Vector3(input.x, 0, input.y)).normalized()
		if movementStyle == 0:
			velocity = Vector3.ZERO
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity = velocity.linear_interpolate(Vector3(direction.x,0,direction.z) * speed, delta * acceleration)
			if input == Vector2.ZERO and frictionEnabled:
				velocity = velocity.linear_interpolate(Vector3.ZERO, delta * friction)
		if player.is_on_floor():
			snapVec = -player.get_floor_normal()
		else:
			snapVec = Vector3.DOWN
		player.move_and_slide_with_snap(velocity,snapVec,Vector3.UP)
