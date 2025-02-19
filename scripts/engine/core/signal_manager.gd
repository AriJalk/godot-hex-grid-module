#Signals that can be accessed globally

#UI signals
#signal map_element_clicked_signal(map_element : MapElement)
signal world_dragged(drag_vector : Vector2)

#Physical input signals
signal mouse_pressed(position: Vector2i, button: int)
signal mouse_moved(position: Vector2i)
signal key_movement(translation: Vector2)
signal wheel_movement(movement : float)
