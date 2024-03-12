class_name Layout

# Layout Constants for verticies.
static var layout_pointy = Orientation.new(
	sqrt(3.0), sqrt(3.0) / 2.0, 0.0, 3.0 / 2.0,
	sqrt(3.0) / 3.0, -1.0 / 3.0, 0.0, 2.0 / 3.0,
	0.5):
		get():
			return layout_pointy

static var layout_flat = Orientation.new(
	3.0 / 2.0, 0.0,
	sqrt(3.0) / 2.0, sqrt(3.0),
	2.0 / 3.0, 0.0, -1.0 / 3.0, sqrt(3.0) / 3.0,
	0.0):
		get():
			return layout_flat
	
var orientation : Orientation
var size : Vector2
var origin : Vector2i

func _init(orientation_ : Orientation, size_ : Vector2, origin_: Vector2i) -> void:
	orientation = orientation_
	size = size_
	origin = origin_
