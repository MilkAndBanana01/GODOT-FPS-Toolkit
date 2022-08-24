extends Node

var player
var camera_settings
var camera_zooming
var camera_panning

var movement_settings
var gravity
var mid_air_settings
var jumping

func _ready() -> void:
	player = get_tree().current_scene.get_node("Player")
