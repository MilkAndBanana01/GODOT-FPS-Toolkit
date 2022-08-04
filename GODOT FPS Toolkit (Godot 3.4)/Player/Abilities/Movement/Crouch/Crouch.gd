extends Node

export var enabled := true
export var crouchSpeed := 5
export var crouchHeight := 0.5
export(int,'Instant','Interpolated') var heightConfiguration := 0
export(float,1,100) var heightInterpolation := 4 
export var allowMidAir := false
export(int,'Affect Height','Affect Speed','Affect Both') var midAirConfiguration := 0

var player
var collision = CollisionShape.new()
var capsule = CapsuleShape.new()
var raycast = RayCast.new()

var movementNode

func _ready() -> void:
	player = owner.get_parent()
	movementNode = get_parent()

	raycast.name = "CheckCeiling"
	raycast.enabled = true
	raycast.cast_to = Vector3(0,1,0)
	raycast.translation.y = ((movementNode.height - crouchHeight) / 2)
	player.call_deferred('add_child',raycast)
	
	collision.name = "InstantCrouch"
	capsule.height = crouchHeight
	capsule.radius = 0.5
	collision.set_shape(capsule)
	collision.rotate_x(deg2rad(90))
	player.call_deferred('add_child',collision)
	collision.translation.y = -((movementNode.height - crouchHeight) / 2)
