extends Node3D

@export var orbit_node : Node3D
@export_range(0.1, 20) var orbit_radius : float
@export_range(0.1, 100) var orbit_rotation_speed : float = 10
@export_range(0.1, 100) var boom_rotation_speed : float = 1
@export var rotation_axis_1 : int = Vector3.AXIS_X
@export var rotation_axis_2 : int = Vector3.AXIS_Y

@onready var _currentRadius = orbit_radius

var _orbit_rotation : float = 0
var _boom_rotation : float = 0


func _physics_process(delta):
	_orbit_rotation += orbit_rotation_speed * delta
	_set_position_on_circle()
	
	_boom_rotation += boom_rotation_speed * delta
	_boom_rotation = _clamp_to_360_degrees(_boom_rotation)
	rotate_y(deg_to_rad(_boom_rotation))
	
	
static func _clamp_to_360_degrees(angle : float) -> float:
	if angle < -360:
		return angle + 360
	elif angle > 360:
		return angle - 360
	return angle
	
	
static func _get_change_vector(rotation_axis : int, value : float) -> Vector3:
	match rotation_axis:
		Vector3.AXIS_X:
			return Vector3(value, 0, 0)
		Vector3.AXIS_Y:
			return Vector3(0, value, 0)
		Vector3.AXIS_Z:
			return Vector3(0, 0, value)
		_:
			return Vector3.ZERO
	

func _set_position_on_circle():
	
	_orbit_rotation = _clamp_to_360_degrees(_orbit_rotation)
	
	var radiansY = deg_to_rad(_orbit_rotation)
		
	var axis1 = cos(radiansY) * _currentRadius
	var axis2 = sin(radiansY) * _currentRadius
	
	var change_vector = _get_change_vector(rotation_axis_1, axis1)
	change_vector += _get_change_vector(rotation_axis_2, axis2)
	var new_position = global_position + change_vector

	orbit_node.global_position = new_position
	
	var up_vector = Vector3.UP
	var direction = (position - orbit_node.position).normalized()
	# Adjust up vector if parallel to origin
	if abs(up_vector.dot(direction)) > 0.999:
		var alternative_up = Vector3.RIGHT if abs(direction.dot(Vector3.RIGHT)) < 0.999 else Vector3.FORWARD
		up_vector = direction.cross(alternative_up).normalized()
	
	orbit_node.look_at(global_position, up_vector)
