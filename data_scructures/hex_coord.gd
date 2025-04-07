#Hexagonal position object
class_name HexCoord
extends RefCounted

static var ZERO : HexCoord = new(0, 0)
static var NULL : HexCoord = new(-999,-999)

static var _cache = {}

var q : int
var r : int

# Factory method
static func get_coord(get_q : int, get_r : int) -> HexCoord:
	var vec = Vector2i(get_q, get_r)
	if not _cache.has(vec):
		_cache[vec] = HexCoord.new(get_q ,get_r)
	return _cache[vec]

	
func _init(q_new : int, r_new : int) -> void:
	q = q_new
	r = r_new


func string() -> String:
	return "Q[" + str(q) + "]R[" + str(r) + "]S[" + str(-q -r) + "]"
	

func equals(other_hex : HexCoord) -> bool:
	if other_hex != null:
		return q == other_hex.q && r == other_hex.r
	return false
	
func get_hash() -> int:
	return q * 17 + r * 31

func duplicate() -> HexCoord:
	return HexCoord.new(q, r)
