extends Camera3D

@export_range(0.1, 2) var scroll_acceleration : float = 1

func _ready() -> void:
	GlobalServices.signal_manager.wheel_movement.connect(_on_scroll)

func _exit_tree() -> void:
	GlobalServices.signal_manager.wheel_movement.disconnect(_on_scroll)

func _on_scroll(scroll_vector : float):
	if size - scroll_vector * 50 > 0.5:
		size -= scroll_vector * 20 * scroll_acceleration
		size = clampf(size, 0.5, 9)
