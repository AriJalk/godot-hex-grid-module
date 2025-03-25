#The Game-Map object, translates between hexagonal position and actual game tile
class_name HexDictionary

var _hex_dictionary = {}

func _init() -> void:
	pass
	
func add(hex_node : HexNode):
	if !_hex_dictionary.has(hex_node.hex_coord.get_hash()):
		_hex_dictionary[hex_node.hex_coord.get_hash()] = hex_node

func remove(hex_coord : HexCoord):
	if _hex_dictionary.has(hex_coord.get_hash()):
		_hex_dictionary.erase(hex_coord.get_hash())

func get_hex(hex : HexCoord) -> HexNode:
	if _hex_dictionary.has(hex.get_hash()):
		return _hex_dictionary[hex.get_hash()]
	return null

func get_all_nodes():
	return _hex_dictionary.values()

func get_neighbor_nodes(hex : HexCoord) -> Array[HexNode]:
	var array : Array[HexNode] = []
	for neighbor in HexUtilities.get_all_neighbors(hex):
		if _hex_dictionary.has(neighbor.get_hash()):
			array.append(_hex_dictionary[neighbor.get_hash()])
	return array
	
func get_neighbor_nodes_no_built(hex : HexCoord) -> Array[HexCoord]:
	var array = get_neighbor_nodes(hex)
	var return_array : Array[HexCoord] = []
	for neighbor in array:
		if neighbor.built:
			return_array.append(neighbor)
	return return_array
	
func get_neighbor_nodes_exclude(hex : HexCoord, exclude : HexCoord) -> Array[HexCoord]:
	var array : Array[HexCoord] = []
	for neighbor in HexUtilities.get_all_neighbors(hex):
		if _hex_dictionary.has(neighbor.get_hash()) and !neighbor.equals(exclude):
			array.append(_hex_dictionary[neighbor.get_hash()])
	return array



func get_size() -> int:
	return _hex_dictionary.size()
	
func clear_dictionary():
	_hex_dictionary.clear()
