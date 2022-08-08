extends Node

export var crosshairTexture : Texture

onready var crosshair = Sprite.new()
var crosshairFolderPath := "res://Player/UI/HUD/Crosshair/"

func _ready() -> void:
	if crosshairTexture != null:
		crosshair.texture = crosshairTexture
	else:
		dir_contents(crosshairFolderPath)
	crosshair.position = Vector2(OS.get_window_size().x,OS.get_window_size().y) / 2
	crosshair.scale = Vector2(0.5,0.5)
	AP.player.call_deferred("add_child",crosshair)

func dir_contents(path):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if ".png" in file_name and not ".import" in file_name:
				crosshair.texture = load(crosshairFolderPath + file_name)
				break
			file_name = dir.get_next()
	else:
		print("Cannot find Crosshairs Folder in UI Folder.")
