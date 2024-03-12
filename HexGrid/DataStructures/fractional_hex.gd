class_name FractionalHex
var q : float
var r : float
var s : float

static func equals(hex_a : Hex, hex_b : Hex) -> bool:
	return hex_a.q == hex_b.q && hex_a.r == hex_b.r && hex_a.s == hex_b.s


func _init(q_new : float, r_new : float, s_new : float) -> void:
	q = q_new
	r = r_new
	s = s_new
	if (round(q + r + s) != 0):
		print("FRACTION Coordinates FAIL")
