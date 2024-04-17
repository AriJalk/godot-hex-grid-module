class_name Hex

static var ZERO : Hex :
	get:
		return new(0,0,0)

static var NULL : Hex :
	get:
		return new(-999,999,0)

var q : int
var r : int
var s : int

var can_be_removed : bool = true

# todo: specific entries
var neighbor_array = HexArray.new()



func _init(q_new : int, r_new : int, s_new : int) -> void:
	q = q_new
	r = r_new
	s = s_new
	if s_new == null:
		s = -q -r
	if q + r + s != 0:
		print("REGULAR Coordinates FAIL")

func _to_string() -> String:
	return "Q[" + str(q) + "]R[" + str(r) + "]S[" + str(s) + "]"
	
func equals(other_hex : Hex) -> bool:
	if other_hex != null:
		return q == other_hex.q && r == other_hex.r && s == other_hex.s
	return false

func duplicate() -> Hex:
	return Hex.new(q, r, s)
