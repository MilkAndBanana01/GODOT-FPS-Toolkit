tool
extends "res://Player/Abilities/Movement/Gravity/Fall.gd"



#n = name
#t = type
#d = default
#e = enabled by
#v = values
#mn = minimum
#mx = maximum


func _get(property: String):
	if property in jumpProp.keys():
		if jumpProp[property]["t"] != "category":
			return get(jumpProp[property]["n"])
func _set(property: String, value) -> bool:
	if property in jumpProp.keys():
		if jumpProp[property].has("mn"):
			value = clamp(value,jumpProp[property]["mn"],INF)
		if jumpProp[property].has("mx"):
			value = clamp(value,-INF,jumpProp[property]["mx"])
		if jumpProp[property].has("mn") and jumpProp[property].has("mx"):
			value = clamp(value,jumpProp[property]["mn"],jumpProp[property]["mx"])
		set(jumpProp[property]["n"], value)
		if jumpProp[property]["t"] == 'bool' or jumpProp[property]["t"] == 'list':
			property_list_changed_notify()
	return true
func _get_property_list() -> Array:
	var props := []
	for i in jumpProp.keys():
		var curr_prop : Dictionary = jumpProp[i]
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
	if property in jumpProp.keys():
		if "d" in jumpProp[property].keys():
			if typeof(jumpProp[property]["d"]) == typeof(get(jumpProp[property]["n"])):
				return true
	return false
func property_get_revert(property:String):
	return jumpProp[property]["d"]

func _ready() -> void:
	if get_parent() is KinematicBody:
		player = get_parent()
	else:
		player = owner.get_parent()

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint() == false:
		if raycast.is_colliding():
			jumpCount = 0
		if Input.is_action_just_pressed('jump') and jumpCount < jumpLimit:
			jumpCount += 1
			jump(Vector3.UP * jumpHeight)
