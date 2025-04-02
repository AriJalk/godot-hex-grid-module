#The Game-Map object, translates between hexagonal position and actual game tile
class_name HexDataDictionary

var _hex_dictionary = {}

func _init() -> void:
	pass
	
func add(hex_data : HexData) -> void:
	if !_hex_dictionary.has(hex_data.coord.get_hash()):
		_hex_dictionary[hex_data.coord.get_hash()] = hex_data

func remove(hex_coord : HexCoord) -> void:
	if _hex_dictionary.has(hex_coord.get_hash()):
		_hex_dictionary.erase(hex_coord.get_hash())

func get_hex(hex : HexCoord) -> HexData:
	if _hex_dictionary.has(hex.get_hash()):
		return _hex_dictionary[hex.get_hash()]
	return null

func get_all_nodes():
	return _hex_dictionary.values()

func get_neighbor_nodes(coord : HexCoord) -> Array[HexData]:
	var array : Array[HexData] = []
	for neighbor in HexUtilities.get_all_neighbors(coord):
		if _hex_dictionary.has(neighbor.get_hash()):
			array.append(_hex_dictionary[neighbor.get_hash()])
	return array
	
func get_neighbor_nodes_no_built(coord : HexCoord) -> Array[HexCoord]:
	var array = get_neighbor_nodes(coord)
	var return_array : Array[HexCoord] = []
	for neighbor in array:
		if neighbor.built:
			return_array.append(neighbor)
	return return_array
	
func get_neighbor_nodes_exclude(coord : HexCoord, exclude : HexCoord) -> Array[HexCoord]:
	var array : Array[HexCoord] = []
	for neighbor in HexUtilities.get_all_neighbors(coord):
		if _hex_dictionary.has(neighbor.get_hash()) and !neighbor.equals(exclude):
			array.append(_hex_dictionary[neighbor.get_hash()])
	return array



func get_size() -> int:
	return _hex_dictionary.size()
	
func clear_dictionary():
	_hex_dictionary.clear()
