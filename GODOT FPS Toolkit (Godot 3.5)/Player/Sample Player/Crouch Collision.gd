tool
extends CollisionShape

func _process(delta: float) -> void:
	var base_height = owner.get_node("Base Collision").shape.height
	$"Debug Crouch Mesh".mesh.mid_height = shape.height
	shape.height = clamp(shape.height,0,base_height)
	translation.y = -(base_height - shape.height) / 2
