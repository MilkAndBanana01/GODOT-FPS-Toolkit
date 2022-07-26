tool
extends Node

var player

var input : Vector2
var direction : Vector3
var velocity : Vector3
var snapVec : Vector3
var jump

var movementEnabled : bool
var movementStyle : int
var speed : int
var acceleration : float
var frictionEnabled : bool
var friction : float
var airMomentumEnabled : bool 
var airMomentumAcc : float
var airMomentumSpeed : int
var airMovementEnabled : bool
var airMovementSpeed : int
var airMovementAcc : float

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
	'acceleration': {"n": 'acceleration',"t": 'float',"d": 5.0,"e": ['movementEnabled=true','movementStyle/0']},
	'enable friction': {"n": 'frictionEnabled',"t": 'bool',"d": false,"e": ['movementEnabled=true','movementStyle/0']},
	'friction': {"n": 'friction',"t": 'float',"d": 2.0,"e": ['movementEnabled=true','frictionEnabled=true','movementStyle/0']},

	'air momentum/enabled': {"n": 'airMomentumEnabled',"t": 'bool',"d": true, 'e': ['airMovementEnabled/true']},
	'air momentum/acceleration': {"n": 'airMomentumAcc',"t": 'float',"d": 1.0,"e": ['airMomentumEnabled=true','movementStyle=1','airMovementEnabled/true'],'mn':0},
	'air momentum/custom speed': {"n": 'airMomentumSpeed',"t": 'int',"d": 0,"e": ['airMomentumEnabled=true','airMovementEnabled/true']},

	'air movement/enabled': {"n": 'airMovementEnabled',"t": 'bool',"d": false},
	'air movement/custom speed': {"n": 'airMovementSpeed',"t": 'int',"d": 0,"e": ['airMovementEnabled=true']},
	'air movement/custom acceleration': {"n": 'airMovementAcc',"t": 'float',"d": 0.0,"e": ['airMovementEnabled=true','movementStyle=1'],'mn': 0},
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
	jump = player.get_node_or_null('Movement/Gravity')
	addCollision()

func addCollision():
	if player.get_node_or_null('Collision') == null:
		var collision = CollisionShape.new()
		var capsule = CapsuleShape.new()
		collision.name = "Collision"
		capsule.radius = 0.5
		collision.set_shape(capsule)
		collision.rotate_x(deg2rad(90))
		player.call_deferred('add_child',collision)

func movePlayer():
	input = Vector2(Input.get_action_strength('move_right') - Input.get_action_strength('move_left'),Input.get_action_strength('move_back') - Input.get_action_strength('move_forward'))
	direction = (player.transform.basis * Vector3(input.x, 0, input.y)).normalized()
func retroMovement(s):
	velocity = Vector3.ZERO
	velocity.x = direction.x * s
	velocity.z = direction.z * s
func modernMovement(s,a,d):
	velocity = velocity.linear_interpolate(Vector3(direction.x,0,direction.z) * s, d * a)
func applyFriction(f,d):
	velocity = velocity.linear_interpolate(Vector3.ZERO, d * f)

func _input(_event: InputEvent) -> void:
	if jump != null and jump.updateDirection:
		if Input.is_action_just_pressed('jump') and jump.jumpCount < jump.jumpLimit:
			movePlayer()
			retroMovement(speed + airMomentumSpeed)
func _physics_process(delta: float) -> void:
	if not Engine.editor_hint:
		if player.is_on_floor():
			movePlayer()
			if movementStyle == 0:
				retroMovement(speed)
			else:
				modernMovement(speed,acceleration,delta)
				if input == Vector2.ZERO and frictionEnabled:
					applyFriction(friction,delta)
		else:
			if airMovementEnabled:
				movePlayer()
				if movementStyle == 1:
					modernMovement((speed + airMovementSpeed),airMovementAcc,delta)
				else:
					retroMovement(speed + airMovementSpeed)
			elif airMomentumEnabled:
				if movementStyle == 1:
					modernMovement((speed + airMomentumSpeed),airMomentumAcc,delta)
				else:
					retroMovement(speed + airMomentumSpeed)
			else:
				velocity = Vector3.ZERO
		player.move_and_slide(velocity,Vector3.UP)
