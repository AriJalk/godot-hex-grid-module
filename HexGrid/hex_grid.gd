class_name HexGrid

enum HexDirections {
	North = 0,
	South = 1,
	NorthWest = 2,
	NorthEast = 3,
	SouthWest = 4,
	SouthEast = 5,
}

# Directions for flattop hexagon
static var hex_directions_dictionary = {
	HexDirections.North : Hex.new(0, -1, +1),
	HexDirections.South : Hex.new(0, +1, -1),
	HexDirections.NorthWest : Hex.new(-1, 0, +1),
	HexDirections.NorthEast : Hex.new(+1, -1, 0),
	HexDirections.SouthWest : Hex.new(-1, +1, 0),
	HexDirections.SouthEast : Hex.new(+1, 0, -1),
}

static func hex_add(a: Hex, b: Hex) -> Hex:
	var new_tile = Hex.new(a.q + b.q, a.r + b.r, a.s + b.s)
	return new_tile

static func hex_subtract(a: Hex, b: Hex) -> Hex:
	var new_tile = Hex.new(a.q - b.q, a.r - b.r, a.s - b.s)
	return new_tile

static func hex_scale(a : Hex, k : int)  -> Hex:
	var new_tile = Hex.new(a.q * k, a.r * k, a.s * k)
	return new_tile


static func hex_neighbor(hex : Hex, direction : HexDirections) -> Hex:
	return hex_add(hex, hex_directions_dictionary[direction])

static func hex_round(h : FractionalHex) -> Hex:
	var qi = round(h.q) as int
	var ri = round(h.r) as int
	var si = round(h.s) as int
	var q_diff = abs(qi - h.q)
	var r_diff = abs(ri - h.r)
	var s_diff = abs(si - h.s)
	if q_diff > r_diff && q_diff > s_diff:
		qi = -ri -si
	elif r_diff > s_diff:
		ri = -qi -si
	else:
		si = -qi - ri;
	#print("QI: ", qi, ", RI: ", ri, ", SI: ", si, "\n")
	return Hex.new(qi, ri, si)

static func hex_lerp(a : FractionalHex, b : FractionalHex, t : float):
	return FractionalHex.new(a.q * (1.0 - t) + b.q * t, a.r * (1.0 - t) + b.r * t, a.s * (1.0 - t) + b.s * t)

static func equal_hex(test_name : String, hex_a : Hex, hex_b : Hex) -> bool:
	#print("HEX A: ", hex_a.q, ",",hex_a.r,",",hex_a.s)
	#print("HEX B: ", hex_b.q, ",",hex_b.r,",",hex_b.s)
	if hex_a.equals(hex_b):
		return true
	print(test_name, " Not Same")
	return false

static func calculate_gap(hex_size: float, gap_proportion: float) -> float:
	# Calculate the gap size as a proportion of the hexagon size 	 
	var gap = hex_size * gap_proportion
	return gap

static func cube_to_world(q: int, r: int, s: int, hex_size: float, gap_proportion: float) -> Vector3:
	var gap = calculate_gap(hex_size, gap_proportion)
	# Assuming layout is flat top
	var orientation = Layout.layout_flat
	var x = (orientation.f0 * q + orientation.f1 * r) * hex_size
	if x > 0:
		x += gap * abs(x)
	elif x < 0:
		x -= gap * abs(x)
	var y = 0  # Assuming hexagons are placed flat on the ground
	var z = (orientation.f2 * q + orientation.f3 * r) * hex_size
	if z > 0:
		z += gap * abs(z)
	elif z < 0:
		z -= gap * abs(z)
	

	return Vector3(x, y, z)
	
static func hex_to_world(hex : Hex, hex_size: float, gap_proportion: float) -> Vector3:
	return cube_to_world(hex.q, hex.r, hex. s, hex_size, gap_proportion)


static func is_visited(hex : Hex, visited : Array[Hex]) -> bool:
	for entry in visited:
		if hex.equals(entry):
			return true
	return false
	

	
static func hex_reachable(start: Hex, movement: int) -> HexArray:
	var visited: HexArray = HexArray.new()
	var fringes: Array[HexArray] = []
	var start_array: HexArray = HexArray.new()
	start_array.append(start)
	fringes.append(start_array)

	for k in range(1, movement + 1):
		fringes.append([])  # Initialize the fringe for this movement step
		for hex in fringes[k - 1].array:
			for neighbor in hex.neighbor_array:
				if !visited.has(neighbor):
					visited.append(neighbor)
					fringes[k].append(neighbor)
	return visited




static func test_hex_round() -> void:
	var a = FractionalHex.new(0.0, 0.0, 0.0)
	var b = FractionalHex.new(1.0, -1.0, 0.0)
	var c = FractionalHex.new(0.0, -1.0, 1.0)
	equal_hex("hex_round 1", Hex.new(5, -10, 5), hex_round(hex_lerp(FractionalHex.new(0.0, 0.0, 0.0), FractionalHex.new(10.0, -20.0, 10.0), 0.5)))
	equal_hex("hex_round 2", hex_round(a), hex_round(hex_lerp(a, b, 0.499)))
	equal_hex("hex_round 3", hex_round(b), hex_round(hex_lerp(a, b, 0.501)))
	equal_hex("hex_round 4", hex_round(a), hex_round(FractionalHex.new(a.q * 0.4 + b.q * 0.3 + c.q * 0.3, a.r * 0.4 + b.r * 0.3 + c.r * 0.3, a.s * 0.4 + b.s * 0.3 + c.s * 0.3)))
	equal_hex("hex_round 5", hex_round(c), hex_round(FractionalHex.new(a.q * 0.3 + b.q * 0.3 + c.q * 0.4, a.r * 0.3 + b.r * 0.3 + c.r * 0.4, a.s * 0.3 + b.s * 0.3 + c.s * 0.4)))
