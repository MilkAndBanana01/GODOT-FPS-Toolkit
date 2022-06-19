@tool
extends Node

var props : Array

var movementEnabled : bool = true
var movementStyle : int = 1
var speed : int = 0
var acceleration : float = 0
var frictionEnabled : bool = false
var friction : float = 0

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

var jumpMovementEnabled : bool
var jumpMovementAllowed : int
var jumpMovementStyle : int
var jumpMovementSpeed : int
var jumpMovementAcc : float

var runningEnabled : bool = true
var runningAirMomentum : int = 0
var runningStyle : int = 0
var runningSpeed : int
var runningAcc : float
var runningAirEnabled : bool

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
var usedAcceleration : float
var input : Vector2
var direction : Vector3
var gravityVec : Vector3


func _get(property):
	## movement PROPERTIES
	if property == 'movement/enabled': return movementEnabled
	if property == 'movement/movement style': return movementStyle
	if property == 'movement/enable friction': return frictionEnabled
	if property == 'movement/speed': return speed
	if property == 'movement/acceleration': return acceleration
	if property == 'movement/friction': return friction


	## GRAVITY PROPERTIES
	if property == 'gravity/enabled': return gravityEnabled
	if property == 'gravity/gravity style': return gravityStyle
	if property == 'gravity/gravity rate': return gravity
	
	if property == 'gravity/enable air momentum': return airMomentumEnabled
	if property == 'gravity/air momentum style': return airMomentumStyle
	if property == 'gravity/air momentum acceleration': return airMomentum

	if property == 'gravity/enable mid air movement': return airMovementEnabled
	if property == 'gravity/mid air movement style': return airMovementStyle
	if property == 'gravity/custom speed': return airMovementSpeed
	if property == 'gravity/custom acceleration': return airMovementAcc

	if property == 'jumping/allow movement after jump': return jumpMovementEnabled
	if property == 'jumping/number of jumps': return jumpMovementAllowed
	if property == 'jumping/speed of movement': return jumpMovementStyle
	if property == 'jumping/custom speed': return jumpMovementSpeed
	if property == 'jumping/custom acceleration': return jumpMovementAcc

	## RUNNING PROPERTIES
	if property == 'running/enabled': return runningEnabled
	if property == 'running/running style': return runningStyle
	if property == 'running/air momentum': return runningAirMomentum
	if property == 'running/speed': return runningSpeed
	if property == 'running/acceleration': return runningAcc

	## JUMPING PROPERTIES
	if property == 'jumping/enabled': return jumpingEnabled
	if property == 'jumping/height': return jumpHeight
	if property == 'jumping/jumps': return availableJumps

func _set(property, value):
	## movement PROPERTIES
	if property == 'movement/enabled': 
		movementEnabled = value
		notify_property_list_changed()
	if property == 'movement/movement style': 
		movementStyle = value
		notify_property_list_changed()
	if property == 'movement/enable friction': 
		frictionEnabled = value
		notify_property_list_changed()
	if property == 'movement/speed':
		value = clamp(value,0,INF)
		speed = value
	if property == 'movement/acceleration':
		value = clamp(value,0,INF)
		acceleration = value
	if property == 'movement/friction':
		value = clamp(value,0,INF)
		friction = value
	
	## GRAVITY PROPERTIES
	if property == 'gravity/enabled': 
		gravityEnabled = value
		notify_property_list_changed()
	if property == 'gravity/gravity style': 
		gravityStyle = value
		notify_property_list_changed()
	if property == 'gravity/enable air momentum': 
		airMomentumEnabled = value
		notify_property_list_changed()
	if property == 'gravity/gravity rate':
		value = clamp(value,0,INF)
		gravity = value
	if property == 'gravity/air momentum style':
		airMomentumStyle = value
		notify_property_list_changed()
	if property == 'gravity/air momentum acceleration':
		value = clamp(value,0,INF)
		airMomentum = value
	if property == 'gravity/enable mid air movement':
		airMovementEnabled = value
		notify_property_list_changed()
	if property == 'gravity/mid air movement style':
		airMovementStyle = value
		notify_property_list_changed()
	if property == 'gravity/custom speed':airMovementSpeed = value
	if property == 'gravity/custom acceleration':airMovementAcc = value
	
	## RUNNING PROPERTIES
	if property == 'running/enabled': 
		runningEnabled = value
		notify_property_list_changed()
	if property == 'running/running style': 
		runningStyle = value
		notify_property_list_changed()
	if property == 'running/air momentum': 
		runningAirMomentum = value
		notify_property_list_changed()
	if property == 'running/speed':
		value = clamp(value,0,INF)
		runningSpeed = value
	if property == 'running/acceleration':
		value = clamp(value,0,INF)
		runningAcc = value


	## JUMPING PROPERTIES
	if property == 'jumping/enabled': 
		jumpingEnabled = value
		notify_property_list_changed()
	if property == 'jumping/height': 
		value = clamp(value,0,INF)
		jumpHeight = value
	if property == 'jumping/jumps': 
		value = clamp(value,1,INF)
		availableJumps = value
	if property == 'jumping/allow movement after jump': 
		jumpMovementEnabled = value
		notify_property_list_changed()
	if property == 'jumping/number of jumps': 
		value = clamp(value,1,availableJumps)
		jumpMovementAllowed = value
	if property == 'jumping/speed of movement': 
		jumpMovementStyle = value
		notify_property_list_changed()
	if property == 'jumping/custom speed': jumpMovementSpeed = value
	if property == 'jumping/custom acceleration': jumpMovementAcc = value


func movement_properties():
	props.append(
		{
			'name': 'Basic Settings',
			'type': TYPE_NIL,
			'usage': PROPERTY_USAGE_CATEGORY
		}
	)
	props.append(
		{
			'name': 'movement/enabled',
			'type': TYPE_BOOL
		}
	)
	if movementEnabled:
		props.append(
			{
				"name":"movement/movement style", 
				"type":TYPE_INT, 
				"hint":2,
				"hint_string":"Retro - No Momentum,Modern - Momentum", 
			}
		)
		props.append(
			{
				'name': 'movement/speed',
				'type': TYPE_INT
			}
		)
		if movementStyle == 1:
			props.append(
				{
					'name': 'movement/acceleration',
					'type': TYPE_FLOAT
				}
			)
			props.append(
				{
					'name': 'movement/enable friction',
					'type': TYPE_BOOL
				}
			)
			if frictionEnabled:
				props.append(
					{
						'name': 'movement/friction',
						'type': TYPE_FLOAT
					}
				)
func gravity_properties():
	props.append(
		{
			'name': 'gravity/enabled',
			'type': TYPE_BOOL
		}
	)
	if gravityEnabled:
		props.append(
			{
				"name":"gravity/gravity style", 
				"type":2, 
				"hint":2, 
				"hint_string":"Linear,Exponential", 
			}
		)
		props.append(
			{
				'name': 'gravity/gravity rate',
				'type': TYPE_FLOAT
			}
		)
		if movementStyle != 0:
			props.append(
				{
					'name': 'gravity/enable air momentum',
					'type': TYPE_BOOL
				}
			)
			if airMomentumEnabled:
				props.append(
					{
						"name":"gravity/air momentum style", 
						"type":2, 
						"hint":2, 
						"hint_string":"Use Movement Acceleration,Add Acceleration,Use Custom Acceleration", 
					}
				)
				if airMomentumStyle != 0:
					props.append(
						{
							'name': 'gravity/air momentum acceleration',
							'type': TYPE_FLOAT
						}
					)
		props.append(
			{
				'name': 'gravity/enable mid air movement',
				'type': TYPE_BOOL
			}
		)
		if airMovementEnabled:
			props.append(
				{
					'name': 'gravity/mid air movement style',
						"type":2, 
						"hint":2, 
						"hint_string":"Use Movement Style,Retro Movement Style,Modern Movement Style", 
				}
			)
			if airMovementStyle != 0:
				props.append(
					{
						'name': 'gravity/custom speed',
						'type': TYPE_INT
					}
				)
			if airMovementStyle == 2:
				props.append(
					{
						'name': 'gravity/custom acceleration',
						'type': TYPE_FLOAT
					}
				)
func running_properties():
	props.append(
		{
			'name': 'running/enabled',
			'type': TYPE_BOOL
		}
	)
	if runningEnabled:
		props.append(
			{
				'name': 'running/running style',
				"type":2, 
				"hint":2, 
				"hint_string":"Use Movement Style,Retro,Modern", 
			}
		)
		props.append(
			{
				'name': 'running/speed',
				'type': TYPE_INT
			}
		)
		if runningStyle == 2 or (movementStyle == 1 and runningStyle == 0):
			props.append(
				{
					'name': 'running/acceleration',
					'type': TYPE_FLOAT
				}
			)
		props.append(
			{
				'name': 'running/allow running mid air',
				'type': TYPE_BOOL
			}
		)
func jumping_properties():
	props.append(
		{
			'name': 'jumping/enabled',
			'type': TYPE_BOOL
		}
	)
	if jumpingEnabled:
		props.append(
			{
				'name': 'jumping/height',
				'type': TYPE_INT
			}
		)
		props.append(
			{
				'name': 'jumping/jumps',
				'type': TYPE_INT
			}
		)
		if not airMovementEnabled:
			props.append(
				{
					'name': 'jumping/allow movement after jump',
					'type': TYPE_BOOL
				}
			)
			if jumpMovementEnabled:
				props.append(
					{
						'name': 'jumping/number of jumps',
						'type': TYPE_INT
					}
				)
				props.append(
					{
						"name":"jumping/speed of movement", 
						"type":2, 
						"hint":2, 
						"hint_string":"Use Movement Acceleration,Use Custom Acceleration", 
					}
				)
				if jumpMovementStyle != 0:
					props.append(
						{
							'name': 'jumping/custom speed',
							'type': TYPE_INT
						}
					)
					if movementStyle == 1:
						props.append(
							{
								'name': 'jumping/custom acceleration',
								'type': TYPE_FLOAT
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
			'name': 'Advanced Settings',
			'type': TYPE_NIL,
			'usage': PROPERTY_USAGE_CATEGORY
		}
	)
	props.append(
		{
			'name': 'sliding/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'wall abilities/climbing/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'wall abilities/jumping/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'wall abilities/sliding/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'wall abilities/sidling (Wall hugging)/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'wall abilities/sidling (Wall hugging)/Peeking/enabled',
			'type': TYPE_BOOL
		}
	)

	props.append(
		{
			'name': 'dashing/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'ledge abilities/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'ledge abilities/ledge grab/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'ledge abilities/ledge hang/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'zooming/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'vaulting/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'rolling/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'down smashing (Diving)/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'leaning/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'grappling/enabled',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'swimming (Floating)/enabled',
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

		if not Input.is_action_pressed('sprint') and \
		(grounded \
		or (airMovementEnabled and airMovementStyle == 0) \
		or (not grounded and jumpMovementEnabled and (jumpCount <= jumpMovementAllowed))):
			if movementStyle == 0:
					print('normal walking')
					player.velocity = Vector3.ZERO
					player.velocity.x = direction.x * (speed + (int(runningEnabled and (Input.is_action_pressed('sprint') and (runningAirEnabled or grounded))) * runningSpeed))
					player.velocity.z = direction.z * (speed + (int(runningEnabled and (Input.is_action_pressed('sprint') and (runningAirEnabled or grounded))) * runningSpeed))
			else:
					player.velocity = player.velocity.lerp(Vector3(direction.x,0,direction.z) * (speed + (int(runningEnabled and Input.is_action_pressed('sprint')) * runningSpeed)),delta * usedAcceleration)

		if airMovementEnabled:
			if not grounded:
				if airMovementStyle == 1:
					player.velocity.x = direction.x * airMovementSpeed
					player.velocity.z = direction.z * airMovementSpeed
				if airMovementStyle == 2:
					player.velocity = player.velocity.lerp(Vector3(direction.x,0,direction.z) * airMovementSpeed,delta * airMovementAcc)

		if runningEnabled and Input.is_action_pressed('sprint'):
			if runningStyle == 2:
				player.velocity = player.velocity.lerp(Vector3(direction.x,0,direction.z) * (speed + (int(runningEnabled and (Input.is_action_pressed('sprint') and (runningAirEnabled or grounded))) * runningSpeed)),delta * runningAcc)

		if input == Vector2.ZERO and frictionEnabled and grounded:
			player.velocity = player.velocity.lerp(Vector3.ZERO,delta * friction)
		player.velocity.y = gravityVec.y

		player.move_and_slide()
