class_name HexUtilities


enum HexDirections {
	NORTH = 0,
	SOUTH = 1,
	NORTH_WEST = 2,
	NORTH_EAST = 3,
	SOUTH_WEST = 4,
	SOUTH_EAST = 5,
}

# Directions for flattop hexagon
static var hex_directions_dictionary = {
	HexDirections.NORTH : Hex.new(0, -1, +1),
	HexDirections.SOUTH : Hex.new(0, +1, -1),
	HexDirections.NORTH_WEST : Hex.new(-1, 0, +1),
	HexDirections.NORTH_EAST : Hex.new(+1, -1, 0),
	HexDirections.SOUTH_WEST : Hex.new(-1, +1, 0),
	HexDirections.SOUTH_EAST : Hex.new(+1, 0, -1),
}

static func hex_add(a: Hex, b: Hex) -> Hex:
	var new_tile = Hex.new(a.q + b.q, a.r + b.r, a.s + b.s)
	return new_tile

static func hex_subtract(a: Hex, b: Hex) -> Hex:
	var new_tile = Hex.new(a.q - b.q, a.r - b.r, a.s - b.s)
	return new_tile


static func hex_neighbor(hex : Hex, direction : HexDirections) -> Hex:
	return hex_add(hex, hex_directions_dictionary[direction])


static func equal_hex(test_name : String, hex_a : Hex, hex_b : Hex) -> bool:
	#print("HEX A: ", hex_a.q, ",",hex_a.r,",",hex_a.s)
	#print("HEX B: ", hex_b.q, ",",hex_b.r,",",hex_b.s)
	if hex_a.equals(hex_b):
		return true
	print(test_name, " Not Same")
	return false

static func _calculate_gap(hex_size: float, gap_proportion: float) -> float:
	# Calculate the gap size as a proportion of the hexagon size 	 
	var gap = hex_size * gap_proportion
	return gap


static func cube_to_world(q: int, r: int, s: int, hex_size: float, gap_proportion: float, orientation : Orientation = Layout.layout_flat) -> Vector3:
	var gap = _calculate_gap(hex_size, gap_proportion)
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
	
static func hex_to_world(hex : Hex, hex_size: float, gap_proportion: float, orientation : Orientation = Layout.layout_flat) -> Vector3:
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
