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

var enabled := true
var sensitivity : float = 0
var smoothing := false
var smoothing_amount : int = 0
var lock_camera := false

func _get(property):
	if property == 'basic/enabled': return enabled
	if property == 'basic/sensitivity': return sensitivity
	if property == 'basic/smoothing': return smoothing
	if property == 'basic/lock_camera': return lock_camera
	if property == 'basic/smoothing_amount': return smoothing_amount

func _set(property, value) -> bool:
	if property == 'basic/enabled': 
		enabled = value
		property_list_changed_notify()
	if property == 'basic/smoothing': 
		smoothing = value
		property_list_changed_notify()
	if property == 'basic/lock_camera': lock_camera = value
	if property == 'basic/sensitivity':
		value = clamp(value,0,10)
		sensitivity = value
	if property == 'basic/smoothing_amount':
		value = clamp(value,0,100)
		smoothing_amount = value
	return true

func _get_property_list() -> Array:
	var props = []
	props.append(
		{
			'name': 'Camera Settings',
			'type': TYPE_NIL,
			'usage': PROPERTY_USAGE_CATEGORY
		}
	)
	props.append(
		{
			'name': 'basic/enabled',
			'type': TYPE_BOOL
		}
	)
	if enabled:
		props.append(
			{
				'name': 'basic/sensitivity',
				'type': TYPE_REAL
			}
		)
		props.append(
			{
				'name': 'basic/smoothing',
				'type': TYPE_BOOL
			}
		)
		if smoothing:
			props.append(
				{
					'name': 'basic/smoothing_amount',
					'type': TYPE_INT
				}
			)
		props.append(
			{
				'name': 'basic/lock_camera',
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
				rotationVelocity = rotationVelocity.linear_interpolate(mouseMovement * (sensitivity * 0.25), (100.5 - smoothing_amount) * .01)
			else:
				rotationVelocity = mouseMovement * (sensitivity * 0.25)
			if not lock_camera:
				player.rotate_y(-deg2rad(rotationVelocity.x))
				head.rotate_x(-deg2rad(rotationVelocity.y))
				head.rotation.x = clamp(head.rotation.x,deg2rad(-90),deg2rad(90))
			mouseMovement = Vector2.ZERO

func updateHeight(n):
	head.translation.y = n
