#Hexagonal position object
class_name HexUnit

static var ZERO : HexUnit :
	get:
		return new(0,0)

static var NULL : HexUnit :
	get:
		return new(-999,999)

var q : int
var r : int
var built : bool

var can_be_removed : bool = true

func _init(q_new : int, r_new : int) -> void:
	q = q_new
	r = r_new


func _to_string() -> String:
	return "Q[" + str(q) + "]R[" + str(r) + "]S[" + str(-q -r) + "]"

func equals(other_hex : HexUnit) -> bool:
	if other_hex != null:
		return q == other_hex.q && r == other_hex.r
	return false
	
func get_hash() -> int:
	return q * 17 + r * 31

func duplicate() -> HexUnit:
	return HexUnit.new(q, r)
