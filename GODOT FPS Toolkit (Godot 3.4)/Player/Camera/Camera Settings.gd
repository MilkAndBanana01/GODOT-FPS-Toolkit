extends Node

export var enable := true
export var mouse_sensitivity := 1.0

onready var head = Ap.player.get_node("Head")

func _ready() -> void:
	Ap.camera_settings = self
	if enable:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_key_pressed(KEY_ESCAPE):
			get_tree().quit()
