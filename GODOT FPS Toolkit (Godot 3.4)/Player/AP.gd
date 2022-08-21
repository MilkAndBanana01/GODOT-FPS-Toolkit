extends Node

var player

func _ready() -> void:
	player = get_tree().current_scene.get_node("Player")
