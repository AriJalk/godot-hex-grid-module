#A camera boom that holds a camera that can be positioned on a circle around this node
class_name RotatedCamera
extends Node3D

@export var drag_control : DragControl
@export var camera : Camera3D
@export_range(1, 20) var camera_radius : float
@export_range(0.1, 5) var movement_speed : float = 3
@export var rotation_acceleration : float = 1

var _horizontal_rotation : float = 90
@onready var _currentRadius = camera_radius
var _drag_vector : Vector2

var _movement_vector = Vector3.ZERO

func _ready():
	
	drag_control.on_drag_signal.connect(_on_drag)
	GlobalServices.signal_manager.key_movement.connect(_on_move)
	GlobalServices.signal_manager.wheel_movement.connect(_on_scroll)
	#TODO: actual reset
	_set_position_on_circle()
	
func _physics_process(delta):
	if _drag_vector != Vector2.ZERO:
		_horizontal_rotation += _drag_vector.x * rotation_acceleration * delta
		_set_position_on_circle()
		
	if _movement_vector != Vector3.ZERO:
		position += _movement_vector * delta * movement_speed
		_movement_vector = Vector3.ZERO

	
func _exit_tree():
	drag_control.on_drag_signal.disconnect(_on_drag)
	GlobalServices.signal_manager.key_movement.disconnect(_on_move)
	GlobalServices.signal_manager.wheel_movement.disconnect(_on_scroll)

func _set_position_on_circle():
	
	if _horizontal_rotation < -360:
		_horizontal_rotation += 360
	elif _horizontal_rotation > 360:
		_horizontal_rotation -= 360
	
	var radiansY = deg_to_rad(_horizontal_rotation)
		
	var x = cos(radiansY) * _currentRadius
	var z = sin(radiansY) * _currentRadius

	
	var new_position = global_position + Vector3(x, 0, z)
	new_position.y = 4  # Maintain the current Y position of the camera

	camera.global_position = new_position
	camera.look_at(global_position)
	_drag_vector = Vector2.ZERO

func _on_drag(drag_vector : Vector2):
	_drag_vector = drag_vector
	
func _on_move(movement_vector : Vector2):
	var forward = (camera.basis.z * Vector3(1,0,1)).normalized()
	var right = (camera.basis.x * Vector3(1,0,1)).normalized()		
	_movement_vector = (movement_vector.x * right + movement_vector.y * forward).normalized() 
	
func _on_scroll(scroll_vector : float):
	if camera.size - scroll_vector * 50 > 0.5:
		camera.size -= scroll_vector * 20
		camera.size = clampf(camera.size, 0.5, 9)
