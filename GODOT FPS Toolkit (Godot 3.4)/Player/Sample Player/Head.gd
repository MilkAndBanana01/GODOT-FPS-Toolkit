tool
extends Spatial

var interpolated := false

func _process(delta: float) -> void:
	var current_height = owner.get_node("Base Collision").shape.height
	var crouch_height = owner.get_node("Crouch Collision").shape.height
	var height = (current_height - (current_height / 2)) + 0.5 if owner.get_node("Base Collision").visible else crouch_height
	translation.y = lerp(translation.y,height,delta * 4) if interpolated else height
