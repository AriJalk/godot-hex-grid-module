extends OrbitNode

@export_range(0, 100) var orbit_speed = 1

func _physics_process(delta: float) -> void:
	orbit_rotation += orbit_speed * delta
	set_position_on_circle()
