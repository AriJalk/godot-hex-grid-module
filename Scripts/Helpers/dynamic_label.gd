class_name DynamicLabel
extends Label

# Adjust font size to fit within the Label's size without expanding the container
func fit_text(max_size: int) -> void:
	var container_rect: Rect2 = get_parent().get_rect()
	var max_x = container_rect.size.x
	var max_y = container_rect.size.y

	# Set the maximum width and height based on the container's size
	set_size(Vector2(max_x, max_y))

	var current_font_size = max_size


	# If the text width exceeds the container's width, reduce the font size
	while size.x > max_x && current_font_size > 8:
		current_font_size -= 1
		add_theme_font_size_override("font_size", current_font_size)
