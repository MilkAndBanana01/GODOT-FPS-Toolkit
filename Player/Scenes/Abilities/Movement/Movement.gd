@tool
extends Node

var props : Array

var movementEnabled : bool = true
var movementStyle : int = 1
var speed : int = 0
var acceleration : float = 0
var frictionEnabled : bool = false
var friction : float = 0
var usedAcceleration : float = 0

var gravityEnabled : bool = true
var gravityStyle : int = 0
var gravity : float = 0
var airMomentumEnabled : bool = false
var airMomentumStyle : int = 0
var airMomentum : float = 0
var airMovementEnabled : bool
var airMovementStyle : int
var airMovementSpeed : int
var airMovementAcc : float

var runningEnabled : bool = true
var runningAirMomentum : int = 0
var runningStyle : int = 0

var jumpingEnabled : bool = true
var jumpHeight : int = 0
var availableJumps : int = 0
var jumpCount : int = 0

#@export_enum("Retro - No Momentum", "Modern - Momentum") var movementStyle: int
#@export var speed : float
#@export var acceleration : float
#@export var gravity = 9.8
#@export var enableJumping = true
#@export var jumpHeigth : int

var player
var grounded : bool
var input : Vector2
var direction : Vector3
var gravityVec : Vector3

func _get(property):
	## movement PROPERTIES
	if property == 'basic/movement/enabled': return movementEnabled
	if property == 'basic/movement/movement style': return movementStyle
	if property == 'basic/movement/enable friction': return frictionEnabled
	if property == 'basic/movement/speed': return speed
	if property == 'basic/movement/acceleration': return acceleration
	if property == 'basic/movement/friction': return friction

	## GRAVITY PROPERTIES
	if property == 'basic/gravity/enabled': return gravityEnabled
	if property == 'basic/gravity/gravity style': return gravityStyle
	if property == 'basic/gravity/gravity rate': return gravity
	if property == 'basic/gravity/enable air momentum': return airMomentumEnabled
	if property == 'basic/gravity/air momentum style': return airMomentumStyle
	if property == 'basic/gravity/air momentum acceleration': return airMomentum
	if property == 'basic/gravity/enable mid air movement': return airMovementEnabled
	if property == 'basic/gravity/mid air movement style': return airMovementStyle
	if property == 'basic/gravity/custom speed': return airMovementSpeed
	if property == 'basic/gravity/custom acceleration': return airMovementAcc
	## RUNNING PROPERTIES
	if property == 'basic/running/enabled': return runningEnabled
	if property == 'basic/running/running style': return runningStyle
	if property == 'basic/running/air momentum': return runningAirMomentum


	## JUMPING PROPERTIES
	if property == 'basic/jumping/enabled': return jumpingEnabled
	if property == 'basic/jumping/height': return jumpHeight
	if property == 'basic/jumping/jumps': return availableJumps

func _set(property, value):
	## movement PROPERTIES
	if property == 'basic/movement/enabled': 
		movementEnabled = value
		notify_property_list_changed()
	if property == 'basic/movement/movement style': 
		movementStyle = value
		notify_property_list_changed()
	if property == 'basic/movement/enable friction': 
		frictionEnabled = value
		notify_property_list_changed()
	if property == 'basic/movement/speed':speed = value
	if property == 'basic/movement/acceleration':acceleration = value
	if property == 'basic/movement/friction':friction = value
	
	## GRAVITY PROPERTIES
	if property == 'basic/gravity/enabled': 
		gravityEnabled = value
		notify_property_list_changed()
	if property == 'basic/gravity/gravity style': 
		gravityStyle = value
		notify_property_list_changed()
	if property == 'basic/gravity/enable air momentum': 
		airMomentumEnabled = value
		notify_property_list_changed()
	if property == 'basic/gravity/gravity rate':gravity = value
	if property == 'basic/gravity/air momentum style':
		airMomentumStyle = value
		notify_property_list_changed()
	if property == 'basic/gravity/air momentum acceleration':airMomentum = value
	if property == 'basic/gravity/enable mid air movement':
		airMovementEnabled = value
		notify_property_list_changed()
	if property == 'basic/gravity/mid air movement style':
		airMovementStyle = value
		notify_property_list_changed()
	if property == 'basic/gravity/custom speed':airMovementSpeed = value
	if property == 'basic/gravity/custom acceleration':airMovementAcc = value
	
	## RUNNING PROPERTIES
	if property == 'basic/running/enabled': 
		runningEnabled = value
		notify_property_list_changed()
	if property == 'basic/running/running style': 
		runningStyle = value
		notify_property_list_changed()
	if property == 'basic/running/air momentum': 
		runningAirMomentum = value
		notify_property_list_changed()

	## JUMPING PROPERTIES
	if property == 'basic/jumping/enabled': 
		jumpingEnabled = value
		notify_property_list_changed()
	if property == 'basic/jumping/height': 
		value = clamp(value,0,INF)
		jumpHeight = value
	if property == 'basic/jumping/jumps': availableJumps = value


func movement_properties():
	props.append(
		{
			'name': 'Movement Settings',
			'type': TYPE_NIL,
			'usage': PROPERTY_USAGE_CATEGORY
		}
	)
	props.append(
		{
			'name': 'basic/movement/enabled',
			'type': TYPE_BOOL
		}
	)
	if movementEnabled:
		props.append(
			{
				"name":"basic/movement/movement style", 
				"type":TYPE_INT, 
				"hint":2,
				"hint_string":"Retro - No Momentum,Modern - Momentum", 
			}
		)
		props.append(
			{
				'name': 'basic/movement/speed',
				'type': TYPE_INT
			}
		)
		if movementStyle == 1:
			props.append(
				{
					'name': 'basic/movement/acceleration',
					'type': TYPE_FLOAT
				}
			)
			props.append(
				{
					'name': 'basic/movement/enable friction',
					'type': TYPE_BOOL
				}
			)
			if frictionEnabled:
				props.append(
					{
						'name': 'basic/movement/friction',
						'type': TYPE_FLOAT
					}
				)
func gravity_properties():
	props.append(
		{
			'name': 'basic/gravity/enabled',
			'type': TYPE_BOOL
		}
	)
	if gravityEnabled:
		props.append(
			{
				"name":"basic/gravity/gravity style", 
				"type":2, 
				"hint":2, 
				"hint_string":"Linear,Exponential", 
			}
		)
		props.append(
			{
				'name': 'basic/gravity/gravity rate',
				'type': TYPE_FLOAT
			}
		)
		props.append(
			{
				'name': 'basic/gravity/enable air momentum',
				'type': TYPE_BOOL
			}
		)
		if airMomentumEnabled:
			props.append(
				{
					"name":"basic/gravity/air momentum style", 
					"type":2, 
					"hint":2, 
					"hint_string":"Use Movement Acceleration,Add Acceleration,Use Custom Acceleration", 
				}
			)
			if airMomentumStyle != 0:
				props.append(
					{
						'name': 'basic/gravity/air momentum acceleration',
						'type': TYPE_FLOAT
					}
				)
		props.append(
			{
				'name': 'basic/gravity/enable mid air movement',
				'type': TYPE_BOOL
			}
		)
		if airMovementEnabled:
			props.append(
				{
					'name': 'basic/gravity/mid air movement style',
						"type":2, 
						"hint":2, 
						"hint_string":"Use Movement Style,Retro Movement Style,Modern Movement Style", 
				}
			)
			if airMovementStyle != 0:
				props.append(
					{
						'name': 'basic/gravity/custom speed',
						'type': TYPE_INT
					}
				)
			if airMovementStyle == 2:
				props.append(
					{
						'name': 'basic/gravity/custom acceleration',
						'type': TYPE_FLOAT
					}
				)
func running_properties():
	props.append(
		{
			'name': 'basic/running/enabled',
			'type': TYPE_BOOL
		}
	)
	if runningEnabled:
		props.append(
			{
				'name': 'basic/running/running style',
				"type":2, 
				"hint":2, 
				"hint_string":"Use Movement Style,Retro,Modern", 
			}
		)
		props.append(
			{
				'name': 'basic/running/speed',
				'type': TYPE_INT
			}
		)
		if runningStyle == 2 or (movementStyle == 1 and runningStyle == 0):
			props.append(
				{
					'name': 'basic/running/acceleration',
					'type': TYPE_FLOAT
				}
			)
		props.append(
			{
				'name': 'basic/running/air momentum',
				"type":2, 
				"hint":2, 
				"hint_string":"Keep Running Speed,Keep Air Momentum Speed,Add Running Speed", 
			}
		)
func jumping_properties():
	props.append(
		{
			'name': 'basic/jumping/enabled',
			'type': TYPE_BOOL
		}
	)
	if jumpingEnabled:
		props.append(
			{
				'name': 'basic/jumping/height',
				'type': TYPE_INT
			}
		)
		props.append(
			{
				'name': 'basic/jumping/jumps',
				'type': TYPE_INT
			}
		)

func _get_property_list() -> Array:
	props = []
	movement_properties()
	gravity_properties()
	running_properties()
	jumping_properties()

	props.append(
		{
			'name': 'basic/crouching/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'basic/crouching/sneaking/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'basic/crouching/crawling/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'basic/crouching/proning/enabled',
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
			'name': 'Movement Settings',
			'type': TYPE_NIL,
			'usage': PROPERTY_USAGE_CATEGORY
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
			'name': 'advanced/wall abilities/sidling (Wall hugging)/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'advanced/wall abilities/sidling (Wall hugging)/Peeking/enabled',
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
			'name': 'advanced/ledge abilities/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'advanced/ledge abilities/ledge grab/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'advanced/ledge abilities/ledge hang/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'advanced/zooming/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'advanced/vaulting/enabled',
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
			'name': 'advanced/down smashing (Diving)/enabled',
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
	props.append(
		{
			'name': 'advanced/swimming (Floating)/enabled',
			'type': TYPE_BOOL
		}
	)
	return props

func _ready() -> void:
	player = get_parent()

func _physics_process(delta):
	
	if Engine.is_editor_hint() == false:

		if not player.is_on_floor():
			grounded = false
			if gravityStyle == 1:
				gravityVec += Vector3.DOWN * gravity * delta
			else:
				if gravityVec.y > 0:
					gravityVec += Vector3.DOWN * gravity * delta
				else:
					gravityVec = Vector3.DOWN * gravity
			if airMomentumEnabled:
				if movementStyle == 0:
					if airMomentumStyle == 0:
						usedAcceleration = speed
					elif airMomentumStyle == 1:
						usedAcceleration = speed + airMomentum
					elif airMomentumStyle == 2:
						usedAcceleration = airMomentum
				else:
					if airMomentumStyle == 1:
						usedAcceleration = acceleration + airMomentum
					elif airMomentumStyle == 2:
						usedAcceleration = airMomentum
		else:
			if movementStyle == 0 and airMomentumStyle == 1:
				usedAcceleration = speed
			else:
				usedAcceleration = acceleration
			gravityVec = -player.get_floor_normal()
			grounded = true

		if jumpCount < availableJumps and Input.is_action_just_pressed('ui_accept'):
			jumpCount += 1
			gravityVec = Vector3.UP * jumpHeight
			input = Input.get_vector('move_left','move_right','move_forward','move_back')
			direction = (player.transform.basis * Vector3(input.x, 0, input.y)).normalized()
			if movementStyle == 0:
				player.velocity.x = direction.x * speed
				player.velocity.z = direction.z * speed
		elif player.is_on_floor():
			jumpCount = 0

		input = Input.get_vector('move_left','move_right','move_forward','move_back')
		direction = (player.transform.basis * Vector3(input.x, 0, input.y)).normalized()

		if movementStyle == 0 and grounded:
			player.velocity = Vector3.ZERO

		if movementStyle == 0:
			if grounded or airMovementEnabled:
				player.velocity.x = direction.x * speed
				player.velocity.z = direction.z * speed
			if airMovementEnabled:
				if not grounded:
					if airMovementStyle == 0:
						player.velocity = player.velocity.lerp(Vector3(direction.x,0,direction.z) * speed,delta * usedAcceleration)
					if airMovementStyle == 2:
						player.velocity = player.velocity.lerp(Vector3(direction.x,0,direction.z) * airMovementSpeed,delta * airMovementAcc)
					if airMovementStyle == 1:
						player.velocity.x = direction.x * airMovementSpeed
						player.velocity.z = direction.z * airMovementSpeed
		else:
			if grounded or airMovementEnabled:
				player.velocity = player.velocity.lerp(Vector3(direction.x,0,direction.z) * speed,delta * usedAcceleration)
			if airMovementEnabled:
				if not grounded:
					if airMovementStyle == 0:
						player.velocity = player.velocity.lerp(Vector3(direction.x,0,direction.z) * speed,delta * usedAcceleration)
					if airMovementStyle == 2:
						player.velocity = player.velocity.lerp(Vector3(direction.x,0,direction.z) * airMovementSpeed,delta * airMovementAcc)
					if airMovementStyle == 1:
						player.velocity.x = direction.x * airMovementSpeed
						player.velocity.z = direction.z * airMovementSpeed

		if input == Vector2.ZERO and frictionEnabled and grounded:
			player.velocity = player.velocity.lerp(Vector3.ZERO,delta * friction)
		player.velocity.y = gravityVec.y
 


		player.move_and_slide()
