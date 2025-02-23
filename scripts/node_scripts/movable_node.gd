# Moves along the xz plane
class_name MovableNode
extends Node3D

@export_range(0.1, 5) var movement_speed : float = 3
@export var moved_node : Node3D
@export var forward_node : Node3D

var _movement_vector = Vector3.ZERO

func _ready() -> void:
	connect_to_signal()
	
func _exit_tree() -> void:
	disconnect_from_signal()

func _physics_process(delta: float) -> void:
	if _movement_vector != Vector3.ZERO:
		position += _movement_vector * delta * movement_speed
		_movement_vector = Vector3.ZERO

func connect_to_signal():
	if not GlobalServices.signal_manager.key_movement.is_connected(_on_move):
		GlobalServices.signal_manager.key_movement.connect(_on_move)

func disconnect_from_signal():
	if GlobalServices.signal_manager.key_movement.is_connected(_on_move):
		GlobalServices.signal_manager.key_movement.disconnect(_on_move)

func _on_move(movement_vector : Vector2):
	var forward = (forward_node.basis.z * Vector3(1,0,1)).normalized()
	var right = (forward_node.basis.x * Vector3(1,0,1)).normalized()		
	_movement_vector = (movement_vector.x * right + movement_vector.y * forward).normalized() 
