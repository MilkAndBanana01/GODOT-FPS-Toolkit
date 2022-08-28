tool
extends KinematicBody

export var base_collision : NodePath
export var base_debug_mesh : NodePath
export var crouch_collision : NodePath
export var crouch_debug_mesh : NodePath
export var head : NodePath
export var height := 1.0
export var crouch_height := 0.0
export(int,"Instant","Interpolated") var crouch_transition := 0
export var crouch_interpolation := 0.0

var load_base_col
var load_crouch_col
var load_head
var load_base_debug_mesh
var load_crouch_debug_mesh


func _enter_tree() -> void:
	Ap.player = self
	Ap.head = get_node(head)
	Ap.camera = get_node(str(head) + "/Camera")


func _ready() -> void:
	loadNodes()


func loadNodes():
	load_base_col = get_node(base_collision)
	load_crouch_col = get_node(crouch_collision)
	load_base_debug_mesh = get_node(base_debug_mesh)
	load_crouch_debug_mesh = get_node(crouch_debug_mesh)
	load_head = get_node(head)


func _process(delta: float) -> void:
	if Engine.editor_hint:
		loadNodes()

		load_base_col.shape.height = height
		load_base_debug_mesh.mesh.mid_height = height

		crouch_height = clamp(crouch_height if crouch_height > 0 else height / 2,0,height)
		load_crouch_col.shape.height = crouch_height
		load_crouch_col.translation.y = -(height - crouch_height) / 2
		load_crouch_debug_mesh.mesh.mid_height = crouch_height

		crouch_interpolation = crouch_interpolation if crouch_interpolation > 0 else 4

	var current_height = (height - (height / 2)) + 0.5 if load_base_col.visible else (load_crouch_col.translation.y + load_crouch_col.shape.height / 2) + 0.5
	load_head.translation.y = lerp(load_head.translation.y,current_height,delta * crouch_interpolation) if crouch_transition == 1 else current_height
