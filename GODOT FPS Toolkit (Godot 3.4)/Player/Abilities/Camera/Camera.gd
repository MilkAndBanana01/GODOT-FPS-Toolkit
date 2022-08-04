tool
extends Node

var player

var movementNode
var crouchNode
var runNode

var currentHeight : float

onready var camera = Camera.new()
onready var head = Spatial.new()

var headExists : bool
var camExists : bool

func addCamera():
	for i in player.get_children():
		if i.name == "Head":
			head = i
			headExists = true
			for child in head.get_children():
				if child is Camera:
					camera = child
					camExists = true
	if not headExists:
		head.name = 'Head'
		player.call_deferred('add_child',head)
		head.call_deferred('set_owner',player)
		head.translation.y = movementNode.height
	if not camExists:
		camera.name = 'Camera'
		head.call_deferred('add_child',camera)
		camera.call_deferred('set_owner',player)

func _ready():
	if not Engine.editor_hint:
		if get_parent() is KinematicBody:
			player = get_parent()
		else:
			player = owner.get_parent()
		movementNode = player.get_node('Movement')
		crouchNode = player.get_node('Movement/Crouch')
		runNode = player.get_node('Movement/Run')
		addCamera()

func _process(delta: float) -> void:
	if not Engine.editor_hint:
		if crouchNode.heightConfiguration == 0:
			head.translation.y = currentHeight
		else:
			head.translation.y = lerp(head.translation.y,currentHeight,crouchNode.heightInterpolation * delta)
		if Input.is_action_pressed('crouch') and (runNode.allowRunningWhileCrouching or not Input.is_action_pressed('run')):
			currentHeight = crouchNode.crouchHeight
		elif not crouchNode.raycast.is_colliding():
			currentHeight = movementNode.height
func updateHeight(h):
	head.translation.y = h

"""
Spent an hour trying to fix this inconistent piece of shit, idk why its not working
here even if its the exact same piece of code. i already deleted the damn import folder
to remove any history on this node and still nothing.
"""

#var properties = {
#	'Camera Settings': {"t": 'category'},
#	'enabled': {"n": 'enabled',"t": "bool"},
#	'sensitivity': {"n": 'sensitivity',"t": 'float',"d": 1.0,'e':['enabled=true']},
#	'enable smoothing': {'n': 'smoothing','t': "bool",'e':['enabled=true']},
#	'smoothing': {"n": 'smoothRate',"t": 'int',"d": 0,'e':['smoothing=true']}
#}
#
#func _get(property: String):
#	if property in properties.keys():
#		if properties[property]["t"] != "category":
#			return get(properties[property]["n"])
#func _set(property: String, value) -> bool:
#	print(properties[property])
#	if property in properties.keys():
#		if properties[property].has("mn"):
#			value = clamp(value,properties[property]["mn"],INF)
#		if properties[property].has("mx"):
#			value = clamp(value,0,properties[property]["mx"])
#		if properties[property].has("mn") and properties[property].has("mx"):
#			value = clamp(value,properties[property]["mn"],properties[property]["mx"])
#		set(properties[property]["n"], value)
#		if properties[property]["t"] == 'bool' or properties[property]["t"] == 'list':
#			property_list_changed_notify()
#	return true
#func _get_property_list() -> Array:
#	var props := []
#	for i in properties.keys():
#		var curr_prop : Dictionary = properties[i]
#		var app = true
#		if curr_prop.has("e"):
#			for s in curr_prop["e"].size():
#				if !evaluate_string(curr_prop["e"][s]):
#					app = false
#					break
#		if !app:
#			continue
#
#		var app_dict : Dictionary = {}
#		app_dict["name"] = i
#		if curr_prop["t"] == 'category':
#			app_dict["type"] = TYPE_NIL
#			app_dict["usage"] = PROPERTY_USAGE_CATEGORY
#		if curr_prop["t"] == 'bool':
#			app_dict["type"] = TYPE_BOOL
#		if curr_prop["t"] == 'int':
#			app_dict["type"] = TYPE_INT
#		if curr_prop["t"] == 'float':
#			app_dict["type"] = TYPE_REAL
#		if curr_prop["t"] == 'list':
#			app_dict["type"] = 2
#			app_dict["hint"] = 3
#			app_dict["hint_string"] = curr_prop["v"]
#
#		props.append(app_dict)
#	return props
#func evaluate_string(eval  : String) -> bool:
#	if "/" in eval:
#		var char_position : int = eval.find("/")
#		var left : String = eval.left(char_position)
#		var right : String = eval.right(char_position+1)
#		if get(left) != str2var(right):
#			return true
#		else: return false
#	elif "=" in eval:
#		var char_position : int = eval.find("=")
#		var left : String = eval.left(char_position)
#		var right : String = eval.right(char_position+1)
#		if get(left) == str2var(right):
#			return true
#		else: return false
#	return false
#func property_can_revert(property:String) -> bool:
#	if property in properties.keys():
#		if "d" in properties[property].keys():
#			if typeof(properties[property]["d"]) == typeof(get(properties[property]["n"])):
#				return true
#	return false
#func property_get_revert(property:String):
#	return properties[property]["d"]

