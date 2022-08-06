extends Node

export var enabled := true
export var crouchSpeed := 5
export var crouchHeight := 0.5
export(int,'Instant','Interpolated') var heightConfiguration := 0
export(float,1,100) var heightInterpolation := 4 
export var allowMidAir := false
export(int,'Affect Height','Affect Speed','Affect Both') var midAirConfiguration := 0

var collision = CollisionShape.new()
var capsule = CapsuleShape.new()
var raycast = RayCast.new()

func _ready() -> void:
	raycast.name = "CheckCeiling"
	raycast.enabled = true
	raycast.cast_to = Vector3(0,0.5,0)
	raycast.translation.y = ((AP.movementNode.height - crouchHeight) / 2)
	AP.player.call_deferred('add_child',raycast)
	
	collision.name = "InstantCrouch"
	capsule.height = crouchHeight
	capsule.radius = 0.5
	collision.set_shape(capsule)
	collision.rotate_x(deg2rad(90))
	AP.player.call_deferred('add_child',collision)
	collision.translation.y = -((AP.movementNode.height - crouchHeight) / 2)
