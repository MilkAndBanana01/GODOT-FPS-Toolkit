extends Node

var player
var camera_settings
var camera_zooming
var camera_panning

func _ready() -> void:
	player = get_tree().current_scene.get_node("Player")
