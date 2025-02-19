#Handles input from physical devices
#TODO: Internal Signals
class_name InputManager
extends Node

var _last_mouse_position : Vector2i

func _ready() -> void:
	_last_mouse_position = get_viewport().get_mouse_position()


func read_input(delta: float) -> void:
	# Read keyboard input
	var translation_vector = Vector2.ZERO

	if Input.is_action_pressed("ui_up"):
		translation_vector += Vector2.UP
	if Input.is_action_pressed("ui_down"):
		translation_vector += Vector2.DOWN
	if Input.is_action_pressed("ui_left"):
		translation_vector += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		translation_vector += Vector2.RIGHT
	

	if translation_vector != Vector2.ZERO:
		GlobalServices.signal_manager.key_movement.emit(translation_vector)

	# Read mouse input
	var mouse_position : Vector2i = get_viewport().get_mouse_position()
	if mouse_position != _last_mouse_position:
		_last_mouse_position = mouse_position
		GlobalServices.signal_manager.mouse_moved.emit(mouse_position)

	# Check for mouse button presses using InputEventMouseButton
	if Input.is_action_just_pressed("ui_select"):
		GlobalServices.signal_manager.mouse_pressed.emit(mouse_position, MOUSE_BUTTON_LEFT)
	if Input.is_action_just_pressed("ui_cancel"):
		GlobalServices.signal_manager.mouse_pressed.emit(mouse_position, MOUSE_BUTTON_RIGHT)
		

	# Mouse wheel
	if Input.is_action_just_released("ui_text_scroll_up"):
		GlobalServices.signal_manager.wheel_movement.emit(delta)
	elif Input.is_action_just_released("ui_text_scroll_down"):
		GlobalServices.signal_manager.wheel_movement.emit(-delta)
		
