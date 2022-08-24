extends Node

export var enabled := true
export var tilt_ammount := 5

onready var head = Ap.player.get_node("Head")

func _physics_process(delta: float) -> void:
	if enabled:
		head.rotation_degrees.z = lerp(head.rotation_degrees.z,-tilt_ammount * Ap.movement_settings.input.x,delta * 4)
