extends Node

export var crosshairTexture : Texture

onready var crosshair = Sprite.new()
var crosshairFolderPath := "res://Player/UI/HUD/Crosshair/"

func _ready() -> void:
	if crosshairTexture != null:
		crosshair.texture = crosshairTexture
	else:
		findImg(crosshairFolderPath)
	crosshair.position = Vector2(OS.get_window_size().x,OS.get_window_size().y) / 2
	crosshair.scale = Vector2(0.5,0.5)
	AP.player.call_deferred("add_child",crosshair)

func findImg(path):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var fileName = dir.get_next()
		while fileName != "":
			if ".png" in fileName and not ".import" in fileName:
				crosshair.texture = load(crosshairFolderPath + fileName)
				break
			fileName = dir.get_next()
	else:
		print("Cannot find images in UI Folder or UI folder is not available.")
