@tool
extends Node

var playerNode
var headNode
var cameraNode
var mouseMovement
var rotationVelocity: Vector2

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
		notify_property_list_changed()
	if property == 'basic/smoothing': 
		smoothing = value
		notify_property_list_changed()
	if property == 'basic/lock_camera': lock_camera = value
	if property == 'basic/sensitivity':
		value = clampf(value,0,10)
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
				'type': TYPE_FLOAT
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
	playerNode = get_parent()
	headNode = get_parent().get_node("Head")
	cameraNode = headNode.get_node("Camera")
	if Engine.is_editor_hint() == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouseMovement = event.relative

func _physics_process(_delta: float) -> void:
	if mouseMovement != null:
		if smoothing:
			rotationVelocity = rotationVelocity.lerp(mouseMovement * (sensitivity * 0.25), (100.5 - smoothing_amount) * .01)
		else:
			rotationVelocity = mouseMovement * (sensitivity * 0.25)
		if not lock_camera:
			playerNode.rotate_y(-deg2rad(rotationVelocity.x))
			headNode.rotate_x(-deg2rad(rotationVelocity.y))
			headNode.rotation.x = clamp(headNode.rotation.x,deg2rad(-90),deg2rad(90))
		mouseMovement = Vector2.ZERO
