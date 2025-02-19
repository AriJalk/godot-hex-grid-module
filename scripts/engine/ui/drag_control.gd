#Invisible ui control to allow moving world nodes without interacting with the world directly
#used for the camera
class_name DragControl
extends Control

signal on_drag_signal(vector : Vector2)

@export_range(0.1, 1) var sensitivity : float = 1

var _is_dragging = false
var _drag_offset = Vector2()

func _ready():
	# Ensure the Control node can receive mouse events
	set_process_input(true)
	# Optional: Change the cursor to indicate the draggable area
	mouse_filter = Control.MOUSE_FILTER_PASS


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				# Start dragging
				_is_dragging = true
				_drag_offset = event.position
				GlobalServices.global_states.is_game_control_locked = true
			else:
				# Stop dragging
				_is_dragging = false
				GlobalServices.global_states.is_game_control_locked = false
	elif event is InputEventMouseMotion and _is_dragging:
		on_drag_signal.emit(event.position - _drag_offset)
		_drag_offset = event.position
