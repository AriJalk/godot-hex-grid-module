class_name TileManager

	
# mark edges to limit camera
var min_x : float
var max_x : float
var min_z : float
var max_z : float

var _grid_node : Node3D
var _node_pool : NodePool
var _slot_dictionary : HexDictionary

# Called when the node enters the scene tree for the first time. 
func _init(grid_node_ : Node3D, node_pool_ : NodePool) -> void:
	_grid_node = grid_node_
	_node_pool = node_pool_
	_slot_dictionary = HexDictionary.new()

# Update the min max positions after a tile was added or removed to set bounds in use for camera
func _update_bounds_from_hex(hex: Hex) -> void:

	var slot_position = HexGrid.hex_to_world(hex, 0.5, 0.1)
	# Update the bounding box
	if slot_position.x < min_x:
		min_x = slot_position.x
	if slot_position.x > max_x:
		max_x = slot_position.x
	if slot_position.z < min_z:
		min_z = slot_position.z
	if slot_position.z > max_z:
		max_z = slot_position.z

# Remove tile from given hex slot
func remove_tile(hex : Hex) ->void:
	var slot = _slot_dictionary.get_hex_slot(hex)
	if slot != null && slot.hex_tile != null && hex.can_be_removed == true:
		_node_pool.return_prefab(GameManager.game_resources[HexTile], slot.hex_tile)
		slot.hex_tile = null
		slot.transperancy_mesh.visible = true
		_remove_neighbor_slots(hex)

# Add tile to given slot
func add_tile(hex_data : Hex, slot : HexSlot) -> HexTile:
	var tile = _node_pool.retrieve_prefab(GameManager.game_resources[HexTile]) as HexTile
	if tile && slot.hex_tile == null:
		#tile.visible = true
		tile.hex_data = hex_data
		slot.add_child(tile)
		slot.hex_tile = tile
		slot.hex_data = hex_data
		#tile.transform.origin = new_position
		build_neighbor_slots(hex_data)
		slot.transperancy_mesh.visible = false
		return tile
	return null
	
func add_slot(hex_data: Hex) -> HexSlot:
	var slot = _node_pool.retrieve_prefab(GameManager.game_resources[HexSlot]) as HexSlot
	if slot:
		slot.hex_data = hex_data
		_grid_node.add_child(slot)
		var new_position = HexGrid.hex_to_world(hex_data, 0.5, 0.1)
		slot.transform.origin = new_position
		# add to slot dictionary
		_slot_dictionary.add(slot)
		slot.transperancy_mesh.visible = true
		
		# Update the bounding box
		_update_bounds_from_hex(hex_data)
		
		return slot
	return null


func get_slot(hex) -> HexSlot:
	return _slot_dictionary.get_hex_slot(hex)
	

func remove_slot(hex : Hex) -> void:
	var slot = _slot_dictionary.get_hex_slot(hex)
	if slot != null && !slot.hex_data.equals(Hex.ZERO):
		if slot.hex_tile != null:
			remove_tile(slot.hex_data)
		_slot_dictionary.remove(slot)
		_node_pool.return_prefab(GameManager.game_resources[HexSlot], slot)
		_update_bounds_from_hex(hex)
		min_x = 0
		max_x = 0
		min_z = 0
		max_z = 0
		for update_slot in _slot_dictionary.slot_dictionary.values():
			_update_bounds_from_hex(update_slot.hex_data)
		#print(slot.hex_data," removed")

func build_neighbor_slots(hex : Hex) -> void:
	for direction in HexGrid.HexDirections.values():	
		var neighbor = HexGrid.hex_neighbor(hex, direction)
		if _slot_dictionary.get_hex_slot(neighbor) == null:
			add_slot(neighbor)
		hex.neighbor_array.add(neighbor)
		neighbor.neighbor_array.add(hex)
	#print("Array size: ", hex.neighbor_array.size())

# Remove neighbor slots that are not seperated
func _remove_neighbor_slots(hex : Hex) -> void:
	for direction in HexGrid.HexDirections.values():
		var neighbor = HexGrid.hex_neighbor(hex, direction)
		if _is_hex_separated(neighbor, hex):
			remove_slot(neighbor)
			hex.neighbor_array.remove(neighbor)
			neighbor.neighbor_array.remove(hex)
	if _is_hex_separated(hex):
		remove_slot(hex)
		

func _is_hex_separated(hex: Hex, exclude_hex: Hex = null) -> bool:
	var hex_slot = _slot_dictionary.get_hex_slot(hex)
	if hex_slot != null && hex_slot.hex_tile != null:
		return false
	for direction in HexGrid.HexDirections.values():
		var neighbor = HexGrid.hex_neighbor(hex, direction)
		var slot = _slot_dictionary.get_hex_slot(neighbor)
		if slot != null && !neighbor.equals(exclude_hex):
			if slot.hex_tile != null:
				return false
	return true

