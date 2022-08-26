extends Node

var player
var movementNode
var moveNode
var gravityNode
var jumpNode
var crouchNode
var runNode
var dashNode
var cameraNode

var variables = [
	"movementNode",
	"moveNode",
	"gravityNode",
	"jumpNode",
	"crouchNode",
	"runNode",
	"dashNode",
	"cameraNode"
]
var nodeNames = [
	"Movement",
	"Movement/Move",
	"Movement/Gravity",
	"Movement/Gravity/Jump Settings",
	"Movement/Crouch",
	"Movement/Run",
	"Movement/Dash",
	"Camera",
]

func _ready() -> void:
	player = get_tree().get_current_scene().get_node_or_null("Player")
	var count = 0
	for i in nodeNames:
		self[variables[count]] = player.get_node_or_null(i)
		count += 1
