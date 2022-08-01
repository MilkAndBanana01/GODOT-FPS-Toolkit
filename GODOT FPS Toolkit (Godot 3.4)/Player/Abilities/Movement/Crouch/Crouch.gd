extends Node

export var enabled := true
export var crouchSpeed := 5
export var crouchHeight := 0.5
export(int,'Instant','Interpolated') var heightConfiguration := 0
export var allowMidAir := false
export(int,'Affect Height','Affect Speed','Affect Both') var midAirConfiguration := 0

var player
var collision = CollisionShape.new()
var capsule = CapsuleShape.new()

var movementNode

# formula for instant crouch coll (x-y) / 2 = z

func _ready() -> void:
	player = owner.get_parent()
	movementNode = get_parent()
	collision.name = "InstantCrouch"
	capsule.height = crouchHeight
	capsule.radius = 0.5
	collision.set_shape(capsule)
	collision.rotate_x(deg2rad(90))
	player.call_deferred('add_child',collision)
	collision.translation.y = -((movementNode.height - crouchHeight) / 2)
