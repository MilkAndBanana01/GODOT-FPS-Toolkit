tool
extends Node

signal updateHeight

var props : Array

var hideAll : bool
var hideBasic : bool
var hideAdvanced : bool
var hideMovement : bool
var hideGravity : bool
var hideRunning : bool
var hideJumping : bool
var hideCrouching : bool
var hideGrabbing : bool
var hideSliding : bool
var hideWall : bool
var hideDashing : bool
var hideLedge : bool
var hideZooming : bool
var hideVaulting : bool
var hideAdvancedCrouching : bool
var hideDownSmashing : bool
var hideLeaning : bool
var hideGrappling : bool
var hideSwimming : bool
var hideRolling : bool

var movementEnabled : bool
var movementStyle : int
var speed : int
var acceleration : float
var frictionEnabled : bool
var friction : float

var gravityEnabled : bool 
var gravity : float
var airMomentumEnabled : bool 
var airMomentumStyle : int
var airMomentum : float
var airMovementEnabled : bool
var airMovementStyle : int
var airMovementSpeed : int
var airMovementAcc : float

var runningEnabled : bool = true
var runningAirMomentum : int
var runningStyle : int
var runningSpeed : int
var runningAcc : float
var runningAirEnabled : bool

var jumpMovementEnabled : bool
var jumpMovementAllowed : int
var jumpMovementStyle : int
var jumpMovementSpeed : int
var jumpMovementAcc : float

var jumpingEnabled : bool
var jumpHeight : float
var availableJumps : int
var jumpCount : int

var crouchingEnabled : bool
var crouchingConfig : int
var decreaseStandingHeight : float
var standingHeight : float
var crouchingSpeed : float
var crouchingHeight : float
var crouchingSpeedConfig : int
var decreaseSpeed : float
var airCrouching : int

var grabbingEnabled : bool
var grabbingReachConfig : int
var grabbingReach : float
var grabbingObjectDistance : float
var throwingPower : float
var grabbingLockRotationEnabled : bool
var grabbingLockEnabled : bool
var grabbingLockX : bool
var grabbingLockY : bool
var grabbingLockZ : bool

var collision
var capsuleMesh
var collExists : bool

var player
var grounded : bool
var usedAcceleration : float
var input : Vector2
var direction : Vector3
var velocity : Vector3
var gravityVec : Vector3
var snapVec : Vector3

func checkBasic(value) -> void:
		if value == true:
			if hideMovement\
			and hideGravity\
			and hideJumping\
			and hideRunning\
			and hideCrouching\
			and hideGrabbing:
				hideBasic = true
				property_list_changed_notify()
		else:
			hideAll = false
			hideBasic = false
			property_list_changed_notify()
		checkAll(value)

func checkAdvanced(value) -> void:
		if value == true:
			if hideSliding\
			and hideWall\
			and hideDashing\
			and hideLedge\
			and hideZooming\
			and hideVaulting\
			and hideAdvancedCrouching\
			and hideDownSmashing\
			and hideLeaning\
			and hideGrappling\
			and hideSwimming\
			and hideRolling:
				hideAdvanced = true
		else:
			hideAll = false
			hideAdvanced = false
		property_list_changed_notify()
		checkAll(value)

func checkAll(value):
	if value == true:
			if hideMovement\
			and hideGravity\
			and hideJumping\
			and hideRunning\
			and hideCrouching\
			and hideGrabbing\
			and hideSliding\
			and hideWall\
			and hideDashing\
			and hideLedge\
			and hideZooming\
			and hideVaulting\
			and hideAdvancedCrouching\
			and hideDownSmashing\
			and hideLeaning\
			and hideGrappling\
			and hideSwimming\
			and hideRolling:
				hideAll = true
				property_list_changed_notify()
	else:
		hideAll = false
		property_list_changed_notify()

func _get(property):
	## DISPLAY SETTINGS
	if property == 'hide all': return hideAll
	if property == 'hide basic': return hideBasic
	if property == 'hide advanced': return hideAdvanced
	
	if property == 'basic/movement': return hideMovement
	if property == 'basic/gravity': return hideGravity
	if property == 'basic/running': return hideRunning
	if property == 'basic/jumping': return hideJumping
	if property == 'basic/crouching': return hideCrouching
	if property == 'basic/grabbing & throwing': return hideGrabbing
	
	if property == 'advanced/sliding': return hideSliding
	if property == 'advanced/wall abilities': return hideWall
	if property == 'advanced/dashing': return hideDashing
	if property == 'advanced/ledge abilities': return hideLedge
	if property == 'advanced/zooming': return hideZooming
	if property == 'advanced/vaulting': return hideVaulting
	if property == 'advanced/advanced crouching': return hideAdvancedCrouching
	if property == 'advanced/down smashing (Diving)': return hideDownSmashing
	if property == 'advanced/leaning': return hideLeaning
	if property == 'advanced/grappling': return hideGrappling
	if property == 'advanced/swimming (Floating)': return hideSwimming
	if property == 'advanced/rolling': return hideRolling
	
	## MOVEMENT PROPERTIES
	if property == 'movement/enabled': return movementEnabled
	if property == 'movement/movement style': return movementStyle
	if property == 'movement/enable friction': return frictionEnabled
	if property == 'movement/speed': return speed
	if property == 'movement/acceleration': return acceleration
	if property == 'movement/friction': return friction

	## GRAVITY PROPERTIES
	if property == 'gravity/enabled': return gravityEnabled
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
	if property == 'running/allow running mid air': return runningAirEnabled

	## JUMPING PROPERTIES
	if property == 'jumping/enabled': return jumpingEnabled
	if property == 'jumping/height': return jumpHeight
	if property == 'jumping/jumps': return availableJumps

	## CROUCHING PROPERTIES
	if property == 'crouching/enabled': return crouchingEnabled
	if property == 'crouching/configuration': return crouchingConfig
	if property == 'crouching/decrease height': return decreaseStandingHeight
	if property == 'crouching/standing height': return standingHeight
	if property == 'crouching/crouching height': return crouchingHeight
	if property == 'crouching/crouching speed': return crouchingSpeed
	if property == 'crouching/speed configuration': return crouchingSpeedConfig
	if property == 'crouching/decrease speed': return decreaseSpeed
	if property == 'crouching/allow crouching mid air': return airCrouching

	## GRABBING PROPERTIES
	if property == 'grabbing & throwing/enabled': return grabbingEnabled
	if property == 'grabbing & throwing/grabbing reach': return grabbingReachConfig
	if property == 'grabbing & throwing/custom reach': return grabbingReach
	if property == 'grabbing & throwing/object distance': return grabbingObjectDistance
	if property == 'grabbing & throwing/throwing power': return throwingPower
	if property == 'grabbing & throwing/enable lock rotation': return grabbingLockRotationEnabled
	if property == 'grabbing & throwing/lock hold': return grabbingLockEnabled
	if property == 'grabbing & throwing/rotation lock/x rotation': return grabbingLockX
	if property == 'grabbing & throwing/rotation lock/y rotation': return grabbingLockY
	if property == 'grabbing & throwing/rotation lock/z rotation': return grabbingLockZ

func _set(property, value):
	
	## DISPLAY SETTINGS
	if property == 'hide all': 
		hideAll = value
		hideBasic = value
		hideMovement = value
		hideGravity = value
		hideRunning = value
		hideJumping = value
		hideCrouching = value
		hideGrabbing = value
		hideAdvanced = value
		hideSliding = value
		hideWall = value
		hideDashing = value
		hideLedge = value
		hideZooming = value
		hideVaulting = value
		hideAdvancedCrouching = value
		hideDownSmashing = value
		hideLeaning = value
		hideGrappling = value
		hideSwimming = value
		hideRolling = value
		checkAll(value)
		property_list_changed_notify()
	if property == 'hide basic':
		hideBasic = value
		hideMovement = value
		hideGravity = value
		hideRunning = value
		hideJumping = value
		hideCrouching = value
		hideGrabbing = value
		checkAll(value)
		property_list_changed_notify()
	if property == 'hide advanced': 
		hideAdvanced = value
		hideSliding = value
		hideWall = value
		hideDashing = value
		hideLedge = value
		hideZooming = value
		hideVaulting = value
		hideAdvancedCrouching = value
		hideDownSmashing = value
		hideLeaning = value
		hideGrappling = value
		hideSwimming = value
		hideRolling = value
		checkAll(value)
		property_list_changed_notify()
	if property == 'basic/movement':
		hideMovement = value
		checkBasic(value)
	if property == 'basic/gravity':
		hideGravity = value
		checkBasic(value)
	if property == 'basic/running': 
		hideRunning = value
		checkBasic(value)
	if property == 'basic/jumping':
		hideJumping = value
		checkBasic(value)
	if property == 'basic/crouching': 
		hideCrouching = value
		checkBasic(value)
	if property == 'basic/grabbing & throwing': 
		hideGrabbing = value
		checkBasic(value)
	if property == 'advanced/sliding': 
		hideSliding = value
		checkAdvanced(value)
	if property == 'advanced/wall abilities': 
		hideWall = value
		checkAdvanced(value)
	if property == 'advanced/dashing':
		hideDashing = value
		checkAdvanced(value)
	if property == 'advanced/ledge abilities': 
		hideLedge = value
		checkAdvanced(value)
	if property == 'advanced/zooming': 
		hideZooming = value
		checkAdvanced(value)
	if property == 'advanced/vaulting': 
		hideVaulting = value
		checkAdvanced(value)
	if property == 'advanced/advanced crouching': 
		hideAdvancedCrouching = value
		checkAdvanced(value)
	if property == 'advanced/down smashing (Diving)': 
		hideDownSmashing = value
		checkAdvanced(value)
	if property == 'advanced/leaning': 
		hideLeaning = value
		checkAdvanced(value)
	if property == 'advanced/grappling': 
		hideGrappling = value
		checkAdvanced(value)
	if property == 'advanced/swimming (Floating)': 
		hideSwimming = value
		checkAdvanced(value)
	if property == 'advanced/rolling': 
		hideRolling = value
		checkAdvanced(value)

	## MOVEMENT PROPERTIES
	if property == 'movement/enabled': 
		movementEnabled = value
		property_list_changed_notify()
	if property == 'movement/movement style': 
		movementStyle = value
		property_list_changed_notify()
	if property == 'movement/enable friction': 
		frictionEnabled = value
		property_list_changed_notify()
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
		property_list_changed_notify()
	if property == 'gravity/enable air momentum': 
		airMomentumEnabled = value
		property_list_changed_notify()
	if property == 'gravity/gravity rate':
		value = clamp(value,0,INF)
		gravity = value
	if property == 'gravity/air momentum style':
		airMomentumStyle = value
		property_list_changed_notify()
	if property == 'gravity/air momentum acceleration':
		value = clamp(value,0,INF)
		airMomentum = value
	if property == 'gravity/enable mid air movement':
		airMovementEnabled = value
		property_list_changed_notify()
	if property == 'gravity/mid air movement style':
		airMovementStyle = value
		property_list_changed_notify()
	if property == 'gravity/custom speed':airMovementSpeed = value
	if property == 'gravity/custom acceleration':airMovementAcc = value
	
	## RUNNING PROPERTIES
	if property == 'running/enabled': 
		runningEnabled = value
		property_list_changed_notify()
	if property == 'running/running style': 
		runningStyle = value
		property_list_changed_notify()
	if property == 'running/air momentum': 
		runningAirMomentum = value
		property_list_changed_notify()
	if property == 'running/speed':
		value = clamp(value,0,INF)
		runningSpeed = value
	if property == 'running/acceleration':
		value = clamp(value,0,INF)
		runningAcc = value
	if property == 'running/allow running mid air': 
		runningAirEnabled = value
		property_list_changed_notify()

	## JUMPING PROPERTIES
	if property == 'jumping/enabled': 
		jumpingEnabled = value
		property_list_changed_notify()
	if property == 'jumping/height': 
		value = clamp(value,0,INF)
		jumpHeight = value
	if property == 'jumping/jumps': 
		value = clamp(value,1,INF)
		availableJumps = value
	if property == 'jumping/allow movement after jump': 
		jumpMovementEnabled = value
		property_list_changed_notify()
	if property == 'jumping/number of jumps': 
		value = clamp(value,1,availableJumps)
		jumpMovementAllowed = value
	if property == 'jumping/speed of movement': 
		jumpMovementStyle = value
		property_list_changed_notify()
	if property == 'jumping/custom speed': jumpMovementSpeed = value
	if property == 'jumping/custom acceleration': jumpMovementAcc = value

	## CROUCHING PROPERTIES
	if property == 'crouching/enabled':
		property_list_changed_notify()
		crouchingEnabled = value
	if property == 'crouching/configuration': 
		property_list_changed_notify()
		crouchingConfig = value
	if property == 'crouching/decrease height': decreaseStandingHeight = value
	if property == 'crouching/standing height': 
		standingHeight = value
		emit_signal("updateHeight",standingHeight)
	if property == 'crouching/crouching height': crouchingHeight = value
	if property == 'crouching/crouching speed': crouchingSpeed = value
	if property == 'crouching/speed configuration': 
		property_list_changed_notify()
		crouchingSpeedConfig = value
	if property == 'crouching/decrease speed': decreaseSpeed = value
	if property == 'crouching/allow crouching mid air': airCrouching = value

	## GRABBING PROPERTIES
	if property == 'grabbing & throwing/enabled': 
		grabbingEnabled = value
		property_list_changed_notify()
	if property == 'grabbing & throwing/grabbing reach': grabbingReachConfig = value
	if property == 'grabbing & throwing/custom reach': grabbingReach = value
	if property == 'grabbing & throwing/object distance': grabbingObjectDistance = value
	if property == 'grabbing & throwing/throwing power': throwingPower = value
	if property == 'grabbing & throwing/enable lock rotation': grabbingLockRotationEnabled = value
	if property == 'grabbing & throwing/lock hold': grabbingLockEnabled = value
	if property == 'grabbing & throwing/rotation lock/x rotation': grabbingLockX = value
	if property == 'grabbing & throwing/rotation lock/y rotation': grabbingLockY = value
	if property == 'grabbing & throwing/rotation lock/z rotation': grabbingLockZ = value

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
				"hint":3,
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
					'type': TYPE_REAL
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
						'type': TYPE_REAL
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
				'name': 'gravity/gravity rate',
				'type': TYPE_REAL
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
						"hint":3, 
						"hint_string":"Use Movement Acceleration,Add Acceleration,Use Custom Acceleration", 
					}
				)
				if airMomentumStyle != 0:
					props.append(
						{
							'name': 'gravity/air momentum acceleration',
							'type': TYPE_REAL
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
						"hint":3, 
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
						'type': TYPE_REAL
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
				"hint":3, 
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
					'type': TYPE_REAL
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
				'type': TYPE_REAL
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
						"hint":3, 
						"hint_string":"Use Movement Speed,Use Custom Speed", 
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
								'type': TYPE_REAL
							}
						)
func crouching_properties():
	props.append(
		{
			'name': 'crouching/enabled',
			'type': TYPE_BOOL
		}
	)
	if crouchingEnabled:
		props.append(
			{
				"name":"crouching/configuration", 
				"type":2, 
				"hint":3, 
				"hint_string":"Decrease from Current Height,Use Custom Heights", 
			}
		)
		if crouchingConfig == 0:
			props.append(
				{
					'name': 'crouching/decrease height',
					'type': TYPE_REAL
				}
			)
		else:
			props.append(
				{
					'name': 'crouching/standing height',
					'type': TYPE_REAL
				}
			)
			props.append(
				{
					'name': 'crouching/crouching height',
					'type': TYPE_REAL
				}
			)
		props.append(
			{
				'name': 'crouching/crouching speed',
				'type': TYPE_REAL
			}
		)
		props.append(
			{
				'name': 'crouching/decrease speed',
				'type': TYPE_REAL
			}
		)
		props.append(
			{
				"name":"crouching/allow crouching mid air", 
				"type":2, 
				"hint":3, 
				"hint_string":"Disabled,Enable,Affect Height,Affect Speed", 
			}
		)
func grabbing_properties():
	props.append(
		{
			'name': 'grabbing & throwing/enabled',
			'type': TYPE_BOOL
		}
	)
	if grabbingEnabled:
		props.append(
			{
					"name":"grabbing & throwing/grabbing reach", 
					"type":2, 
					"hint":3, 
					"hint_string":"Custom Reach,Infinite Reach"
			}
		)
		if grabbingReachConfig == 1:
			props.append(
				{
					'name': 'grabbing & throwing/custom reach',
					'type': TYPE_REAL
				}
			)
		props.append(
			{
				'name': 'grabbing & throwing/object distance',
				'type': TYPE_REAL
			}
		)
		props.append(
			{
				'name': 'grabbing & throwing/throwing power',
				'type': TYPE_REAL
			}
		)
		props.append(
			{
				'name': 'grabbing & throwing/grabbing speed',
				'type': TYPE_REAL
			}
		)
		props.append(
			{
				'name': 'grabbing & throwing/enable grabbing lock',
				'type': TYPE_BOOL
			}
		)
		props.append(
			{
				'name': 'grabbing & throwing/enable lock rotation',
				'type': TYPE_BOOL
			}
		)
		props.append(
			{
				'name': 'grabbing & throwing/rotation lock/x rotation',
				'type': TYPE_BOOL
			}
		)
		props.append(
			{
				'name': 'grabbing & throwing/rotation lock/y rotation',
				'type': TYPE_BOOL
			}
		)
		props.append(
			{
				'name': 'grabbing & throwing/rotation lock/z rotation',
				'type': TYPE_BOOL
			}
		)

func display_settings():
	props.append(
		{
			'name': 'Hide Settings',
			'type': TYPE_NIL,
			'usage': PROPERTY_USAGE_CATEGORY
		}
	)
	props.append(
		{
			'name': 'hide all',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'hide basic',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'basic/movement',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'basic/gravity',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'basic/running',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'basic/jumping',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'basic/crouching',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'basic/grabbing & throwing',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'hide advanced',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'advanced/sliding',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'advanced/wall abilities',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'advanced/dashing',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'advanced/ledge abilities',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'advanced/zooming',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'advanced/vaulting',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'advanced/advanced crouching',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'advanced/down smashing (Diving)',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'advanced/leaning',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'advanced/grappling',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'advanced/swimming (Floating)',
			'type': TYPE_BOOL
		}
	)
	props.append(
		{
			'name': 'advanced/rolling',
			'type': TYPE_BOOL
		}
	)

func _get_property_list() -> Array:
	props = []
	if not hideAll:
		if not hideBasic:
			if not hideMovement:
				movement_properties()
			if not hideGravity:
				gravity_properties()
			if not hideRunning:
				running_properties()
			if not hideJumping:
				jumping_properties()
			if not hideCrouching:
				crouching_properties()
			if not hideGrabbing:
				grabbing_properties()

		if not hideAdvanced:
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
					'name': 'advanced crouching/enabled',
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
			props.append(
				{
					'name': 'rolling/enabled',
					'type': TYPE_BOOL
				}
			)

	display_settings()

	return props

func _ready() -> void:
	if Engine.is_editor_hint() == false:
		player = get_parent()
		for i in get_children():
			if i is CollisionShape:
				collision = i
				collExists = true
		if not collExists:
			collision = CollisionShape.new()
			collision.name = "Collision"
			var capsule = CapsuleShape.new()
			capsule.height = standingHeight
			capsule.radius = 0.5
			collision.set_shape(capsule)
			collision.rotate_x(deg2rad(90))

			capsuleMesh = CapsuleMesh.new()
			capsuleMesh.radius = 0.5
			var mesh = MeshInstance.new()
			mesh.set_mesh(capsuleMesh)

			player.call_deferred('add_child',collision)
			collision.call_deferred('set_owner',player)
			player.call_deferred('add_child',collision)
			collision.call_deferred('set_owner',player)
			collision.call_deferred('add_child',mesh)
			mesh.call_deferred('set_owner',player)

		if crouchingConfig == 0:
			standingHeight = 1
			crouchingHeight = standingHeight - decreaseStandingHeight

		capsuleMesh.mid_height = standingHeight

		var inputs := ["move_left","move_right","move_back","move_forward","jump","sprint","crouch"]
		var keyCodes := [KEY_A,KEY_D,KEY_S,KEY_W,KEY_SPACE,KEY_SHIFT,KEY_CONTROL]
		var pos := 0
		for i in inputs:
			if InputMap.has_action(i):
				var inputEvent = InputEventKey.new()
				inputEvent.scancode = keyCodes[pos]
				if InputMap.action_has_event(i,inputEvent):
					pass
				else:
					InputMap.action_add_event(i,inputEvent)
			pos += 1
		connect('updateHeight',player.get_node("Camera"),"updateHeight")
		emit_signal("updateHeight",standingHeight)

func _physics_process(delta):
	if Engine.is_editor_hint() == false:
		grounded = player.is_on_floor()

# CAPTURING INPUTS
		input = Input.get_vector('move_left','move_right','move_forward','move_back')
		direction = (player.transform.basis * Vector3(input.x, 0, input.y)).normalized()

# INTERPOLATING PLAYER HEIGHT INPUTS
		if crouchingConfig == 0:
			collision.shape.height = lerp(
				collision.shape.height,
				standingHeight - (int(Input.is_action_pressed('crouch')) * decreaseStandingHeight),
				delta * crouchingSpeed)
			capsuleMesh.mid_height = lerp(
				capsuleMesh.mid_height,
				standingHeight - (int(Input.is_action_pressed('crouch')) * decreaseStandingHeight),
				delta * crouchingSpeed)
		else:
			collision.shape.height = lerp(
				collision.shape.height,
				(int(not Input.is_action_pressed('crouch')) * standingHeight) + 
				(int(Input.is_action_pressed('crouch')) * crouchingHeight),
				delta * crouchingSpeed)
			capsuleMesh.mid_height = lerp(
				capsuleMesh.mid_height,
				(int(not Input.is_action_pressed('crouch')) * standingHeight) + 
				(int(Input.is_action_pressed('crouch')) * crouchingHeight),
				delta * crouchingSpeed)
# GRAVITY
		if grounded:
			jumpCount = 0
			snapVec = -player.get_floor_normal()
			gravityVec = Vector3.ZERO
			usedAcceleration = acceleration
		else:
			snapVec = Vector3.DOWN
			gravityVec += Vector3.DOWN * gravity * delta
			usedAcceleration = acceleration
			if airMomentumEnabled:
				if airMomentumStyle == 0:
					usedAcceleration = acceleration
				if airMomentumStyle == 1:
					usedAcceleration = acceleration + airMomentum
				if airMomentumStyle == 2:
					usedAcceleration = airMomentum

		var currentSpeed = ((speed 
		+ (int(runningEnabled and Input.is_action_pressed("sprint"))) * runningSpeed) 
		- (int(crouchingEnabled and Input.is_action_pressed('crouch') and \
		grounded or not (airCrouching != 0 or airCrouching != 2))) * decreaseSpeed)

# JUMPING
		if Input.is_action_just_pressed("jump") and \
		(grounded or \
		jumpCount < availableJumps or \
		airMovementEnabled):
			jumpCount += 1
			snapVec = Vector3.ZERO
			gravityVec = Vector3.UP * jumpHeight
			direction = (player.transform.basis * Vector3(input.x, 0, input.y)).normalized()
			velocity.x = direction.x * currentSpeed
			velocity.z = direction.z * currentSpeed

# MOVEMENT STYLE
		if grounded:
			if movementStyle == 0:
				velocity = Vector3.ZERO
				velocity.x = direction.x * currentSpeed
				velocity.z = direction.z * currentSpeed
			else:
				velocity = velocity.linear_interpolate(Vector3(direction.x,0,direction.z) * currentSpeed, delta * usedAcceleration)

# FRICTION
			if frictionEnabled and input == Vector2.ZERO:
				velocity = velocity.linear_interpolate(Vector3.ZERO, delta * friction)

# AIR MOVEMENT
		else:
			if airMovementEnabled:
				if airMovementStyle == 1:
					velocity = Vector3.ZERO
					velocity.x = direction.x * airMovementSpeed
					velocity.z = direction.z * airMovementSpeed
				elif airMovementStyle == 2:
					velocity = velocity.linear_interpolate(Vector3(direction.x,0,direction.z) * airMovementSpeed, delta * airMovementAcc)

# JUMP MOVEMENT
			if jumpMovementEnabled and (jumpCount < jumpMovementAllowed):
				var jumpAirSpeed : int
				if jumpMovementStyle == 0:
					jumpAirSpeed = currentSpeed
				elif airMovementStyle == 1:
					jumpAirSpeed = jumpMovementSpeed
					if movementStyle == 0:
						velocity = Vector3.ZERO
						velocity.x = direction.x * jumpAirSpeed
						velocity.z = direction.z * jumpAirSpeed
					else:
						velocity = velocity.linear_interpolate(Vector3(direction.x,0,direction.z) * jumpAirSpeed, delta * jumpMovementAcc)


		velocity.y = gravityVec.y
		player.move_and_slide_with_snap(velocity,snapVec,Vector3.UP)
