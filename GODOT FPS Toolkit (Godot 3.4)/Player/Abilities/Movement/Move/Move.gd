tool
extends Node

var player

var input : Vector2
var direction : Vector3
var velocity : Vector3
var snapVec : Vector3

var movementEnabled : bool
var movementStyle : int
var speed : int
var acceleration : float
var frictionEnabled : bool
var friction : float

#n = name
#t = type
#d = default
#e = enabled by
#v = values
#mn = minimum
#mx = maximum

var properties = {
	'Movement Settings': {"t": 'category'},
	'enabled': {"n": 'movementEnabled',"t": 'bool',"d": true},
	'movement style': {"n": 'movementStyle',"t": 'list',"d": 0,"e": ['movementEnabled=true'],"v": "Retro,Modern"},
	'speed': {"n": 'speed',"t": 'int',"d": 10,"e": ['movementEnabled=true']},
	'acceleration': {"n": 'acceleration',"t": 'float',"d": 5,"e": ['movementEnabled=true','movementStyle/0']},
	'enable friction': {"n": 'frictionEnabled',"t": 'bool',"d": false,"e": ['movementEnabled=true','movementStyle/0']},
	'friction': {"n": 'friction',"t": 'float',"d": 2,"e": ['movementEnabled=true','frictionEnabled=true','movementStyle/0']},
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

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint() == false:
		input = Vector2(Input.get_action_strength('move_right') - Input.get_action_strength('move_left'),Input.get_action_strength('move_back') - Input.get_action_strength('move_forward'))
		direction = (player.transform.basis * Vector3(input.x, 0, input.y)).normalized()
		if movementStyle == 0:
			velocity = Vector3.ZERO
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity = velocity.linear_interpolate(Vector3(direction.x,0,direction.z) * speed, delta * acceleration)
			if input == Vector2.ZERO and frictionEnabled:
				velocity = velocity.linear_interpolate(Vector3.ZERO, delta * friction)
		if player.is_on_floor():
			snapVec = -player.get_floor_normal()
		else:
			snapVec = Vector3.DOWN
		player.move_and_slide_with_snap(velocity,snapVec,Vector3.UP)
