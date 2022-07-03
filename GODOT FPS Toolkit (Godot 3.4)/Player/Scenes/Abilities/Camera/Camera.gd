tool
extends Node

var player
var mouseMovement
var rotationVelocity: Vector2

var movement

var head
var headExists : bool
var camera
var camExists : bool

var enabled : bool
var sensitivity : float
var smoothing : bool
var smoothingAmount : int
var lockCamera : bool

func _get(property):
	if property == 'enabled': return enabled
	if property == 'sensitivity': return sensitivity
	if property == 'smoothing': return smoothing
	if property == 'lock camera': return lockCamera
	if property == 'smoothing amount': return smoothingAmount

func _set(property, value) -> bool:
	if property == 'enabled': 
		enabled = value
		property_list_changed_notify()
	if property == 'smoothing': 
		smoothing = value
		property_list_changed_notify()
	if property == 'lock camera': lockCamera = value
	if property == 'sensitivity':
		value = clamp(value,0,10)
		sensitivity = value
	if property == 'smoothing amount':
		value = clamp(value,0,100)
		smoothingAmount = value
	return true

func _get_property_list() -> Array:
	var props = []
	props.append(
		{
			'name': 'Basic Settings',
			'type': TYPE_NIL,
			'usage': PROPERTY_USAGE_CATEGORY
		}
	)
	props.append(
		{
			'name': 'enabled',
			'type': TYPE_BOOL
		}
	)
	if enabled:
		props.append(
			{
				'name': 'sensitivity',
				'type': TYPE_REAL
			}
		)
		props.append(
			{
				'name': 'smoothing',
				'type': TYPE_BOOL
			}
		)
		if smoothing:
			props.append(
				{
					'name': 'smoothing amount',
					'type': TYPE_INT
				}
			)
		props.append(
			{
				'name': 'lock camera',
				'type': TYPE_BOOL
			}
		)
	return props

func _ready():
	if Engine.is_editor_hint() == false:
		player = get_parent()
		for i in player.get_children():
			if i.name == "Head":
				head = i
				headExists = true
				for child in head.get_children():
					if child is Camera:
						camera = child
						camExists = true
		if not headExists:
			head = Spatial.new()
			head.name = 'Head'
			player.call_deferred('add_child',head)
			head.call_deferred('set_owner',player)
		if not camExists:
			camera = Camera.new()
			camera.name = 'Camera'
			head.call_deferred('add_child',camera)
			camera.call_deferred('set_owner',player)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		movement = player.get_node("Movement")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouseMovement = event.relative
	else:
		mouseMovement = Vector2.ZERO
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint() == false:

		head.translation.y = lerp(
			head.translation.y,
			(int(not Input.is_action_pressed('crouch')) * movement.standingHeight) + 
			(int(Input.is_action_pressed('crouch')) * movement.crouchingHeight),
			delta * movement.crouchingSpeed)

		if mouseMovement != null:
			if smoothing:
				rotationVelocity = rotationVelocity.linear_interpolate(mouseMovement * (sensitivity * 0.25), (100.5 - smoothingAmount) * .01)
			else:
				rotationVelocity = mouseMovement * (sensitivity * 0.25)
			if not lockCamera:
				player.rotate_y(-deg2rad(rotationVelocity.x))
				head.rotate_x(-deg2rad(rotationVelocity.y))
				head.rotation.x = clamp(head.rotation.x,deg2rad(-90),deg2rad(90))
			mouseMovement = Vector2.ZERO

func updateHeight(n):
	head.translation.y = n
