tool
extends Node

var player
var gravityVec : Vector3
var snapVec : Vector3
var jumping = false
var jumpCount : int

onready var raycast = RayCast.new()

var gravityEnabled : bool
var gravityStyle : int
var gravity : float
var gravityLimitEnabled : bool 
var gravityLimit : float
var jumpEnabled : bool
var jumpHeight : int
var jumpLimit : int
var updateDirection : bool

var properties = {
	'Gravity Settings': {"t": 'category'},
	'gravity/enabled': {"n": 'gravityEnabled',"t": 'bool',"d": true},
	'gravity/gravity style': {"n": 'gravityStyle',"t": 'list',"d": 1,"e": ['gravityEnabled=true'],"v": "Constant,Exponential"},
	'gravity/gravity': {"n": 'gravity',"t": 'float',"d": 10,"e": ['gravityEnabled=true']},

	'Jump Settings': {"t": 'category'},
	'enabled': {"n": 'jumpEnabled',"t": 'bool',"d": true},
	'jump height': {"n": 'jumpHeight',"t": 'int',"d": 10},
	'jump count': {"n": 'jumpLimit',"t": 'int',"d": 1, 'mn' : 1},
	'update direction': {"n": 'updateDirection',"t": 'bool',"d": true}
}

func _get(property: String):
	if property in properties.keys():
		if properties[property]["t"] != "category":
			return get(properties[property]["n"])
func _set(property: String, value) -> bool:
	if property in properties.keys():
		if properties[property].has("mn"):
			value = clamp(value,properties[property]["mn"],INF)
		if properties[property].has("mx"):
			value = clamp(value,-INF,properties[property]["mx"])
		if properties[property].has("mn") and properties[property].has("mx"):
			value = clamp(value,properties[property]["mn"],properties[property]["mx"])
		set(properties[property]["n"], value)
		if properties[property]["t"] == 'bool' or properties[property]["t"] == 'list':
			property_list_changed_notify()
	return true
func _get_property_list() -> Array:
	var props := []
	for i in properties.keys():
		var curr_prop : Dictionary = properties[i]
		var app = true
		if curr_prop.has("e"):
			for s in curr_prop["e"].size():
				if !evaluate_string(curr_prop["e"][s]):
					app = false
					break
		if !app:
			continue

		var app_dict : Dictionary = {}
		app_dict["name"] = i
		if curr_prop["t"] == 'category':
			app_dict["type"] = TYPE_NIL
			app_dict["usage"] = PROPERTY_USAGE_CATEGORY
		if curr_prop["t"] == 'bool':
			app_dict["type"] = TYPE_BOOL
		if curr_prop["t"] == 'int':
			app_dict["type"] = TYPE_INT
		if curr_prop["t"] == 'float':
			app_dict["type"] = TYPE_REAL
		if curr_prop["t"] == 'list':
			app_dict["type"] = 2
			app_dict["hint"] = 3
			app_dict["hint_string"] = curr_prop["v"]

		props.append(app_dict)
	return props
func evaluate_string(eval  : String) -> bool:
	if "/" in eval:
		var char_position : int = eval.find("/")
		var left : String = eval.left(char_position)
		var right : String = eval.right(char_position+1)
		if get(left) != str2var(right):
			return true
		else: return false
	elif "=" in eval:
		var char_position : int = eval.find("=")
		var left : String = eval.left(char_position)
		var right : String = eval.right(char_position+1)
		if get(left) == str2var(right):
			return true
		else: return false
	return false
func property_can_revert(property:String) -> bool:
	if property in properties.keys():
		if "d" in properties[property].keys():
			if typeof(properties[property]["d"]) == typeof(get(properties[property]["n"])):
				return true
	return false
func property_get_revert(property:String):
	return properties[property]["d"]

func _ready() -> void:
	if get_parent() is KinematicBody:
		player = get_parent()
	else:
		player = owner.get_parent()
	raycast.cast_to = Vector3(0,-1.2,0)
	raycast.enabled = true
	player.call_deferred('add_child',raycast)

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint() == false:
		if raycast.is_colliding() and not Input.is_action_pressed('jump'):
			jumpCount = 0
		if Input.is_action_just_pressed('jump') and jumpCount < jumpLimit:
			snapVec = Vector3.ZERO
			gravityVec = jumpHeight * Vector3.UP
			jumpCount += 1
		if player.is_on_floor():
			gravityVec = Vector3.ZERO
			snapVec = -player.get_floor_normal()
		else:
			snapVec = Vector3.DOWN
			if gravityStyle == 1:
				gravityVec += Vector3.DOWN * gravity * delta
			else:
				gravityVec = Vector3.DOWN * gravity
		player.move_and_slide_with_snap(gravityVec,snapVec,Vector3.UP)
