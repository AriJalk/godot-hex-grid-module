class_name RotatedCamera
extends OrbitNode

@export var drag_control : DragControl
@export var camera : Camera3D
@export var rotation_acceleration : float = 1

const offset_vector = Vector3(0, 4, 0)

var _drag_vector : Vector2

func _ready():
	orbit_node = camera
	drag_control.on_drag_signal.connect(_on_drag)

	orbit_rotation = 90
	set_position_on_circle(offset_vector)
	
func _exit_tree() -> void:
	drag_control.on_drag_signal.disconnect(_on_drag)
	
func _physics_process(delta: float) -> void:
	if (_drag_vector != Vector2.ZERO):
		orbit_rotation += _drag_vector.x * rotation_acceleration * delta
		set_position_on_circle(offset_vector)
		_drag_vector = Vector2.ZERO
	
func _on_drag(drag_vector : Vector2):
	_drag_vector = drag_vector
	
