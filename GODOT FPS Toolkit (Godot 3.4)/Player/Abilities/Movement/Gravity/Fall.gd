tool
extends Node

var player
var move
var gravityVec : Vector3

var gravityEnabled : bool
var gravityStyle : int
var gravity : float
var gravityLimitEnabled : bool 
var gravityLimit : float
var airMomentumEnabled : bool 
var airMomentumStyle : int
var airMomentum : float
var airMovementEnabled : bool
var airMovementStyle : int
var airMovementSpeed : int
var airMovementAcc : float

var properties = {
	'Gravity Settings': {"t": 'category'},
	'gravity/enabled': {"n": 'gravityEnabled',"t": 'bool',"d": true},
	'gravity/gravity style': {"n": 'gravityStyle',"t": 'list',"d": 0,"e": ['gravityEnabled=true'],"v": "Constant,Exponential"},
	'gravity/gravity': {"n": 'gravity',"t": 'float',"d": 10,"e": ['gravityEnabled=true']},
	'air momentum/enabled': {"n": 'airMomentumEnabled',"t": 'bool',"d": true},
}

func _get(property: String):
	if property in properties.keys():
		if properties[property]["t"] != "category":
			return get(properties[property]["n"])
func _set(property: String, value) -> bool:
	if property in properties.keys():
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
		move = owner.get_node('Move')

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint() == false:
		if player.is_on_floor():
			gravityVec = Vector3.ZERO
		else:
			if gravityStyle == 1:
				gravityVec += Vector3.DOWN * gravity * delta
			else:
				gravityVec = Vector3.DOWN * gravity
		player.move_and_slide(gravityVec)
