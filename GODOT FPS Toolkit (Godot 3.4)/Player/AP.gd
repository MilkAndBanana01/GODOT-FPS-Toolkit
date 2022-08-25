extends Node

var player
var head
var camera

var camera_settings
var camera_zooming
var camera_panning
var dynamic_FOV

var movement_settings
var gravity
var mid_air_settings
var jumping
var running
var flying

func _ready() -> void:
	player = get_tree().current_scene.get_node("Player")
	head = player.get_node("Head")
	camera = player.get_node("Head/Camera")
