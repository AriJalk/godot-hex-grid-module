extends Node3D

const HexDictionary = preload("res://scripts/node_scripts/map/hex_node_dictionary.gd")
const HexNode = preload("res://scripts/node_scripts/hex_node.gd")

var hex_dictionary : HexDictionary

func _init():
	hex_dictionary = HexDictionary.new()
	GlobalServices.node_pool.register_node("hex_node", preload("res://nodes/hex_node.tscn"))
	build_map()
	

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("ui_left")):
		remove_tile(HexUtilities.hex_neighbor(HexUnit.ZERO, HexUtilities.HexDirections.NORTH_WEST))
	if (Input.is_action_just_pressed("ui_right")):
		remove_tile(HexUtilities.hex_neighbor(HexUnit.ZERO, HexUtilities.HexDirections.NORTH_EAST))
	if (Input.is_action_just_pressed("ui_down")):
		remove_tile(HexUtilities.hex_neighbor(HexUnit.ZERO, HexUtilities.HexDirections.SOUTH))
	if (Input.is_action_just_pressed("ui_up")):
		remove_tile(HexUtilities.hex_neighbor(HexUnit.ZERO, HexUtilities.HexDirections.NORTH))

func build_tile(hex_unit : HexUnit):
	var hex_node = GlobalServices.node_pool.retrieve_node("hex_node") as HexNode
	hex_node.hex_unit = hex_unit
	hex_dictionary.add(hex_node)
	add_child(hex_node)
	hex_node.position = HexUtilities.hex_to_world(hex_unit, HexNode.MESH_RADIUS, 0.2)
	

func remove_tile(hex_unit : HexUnit):
	var hex_node = hex_dictionary.get_hex(hex_unit)
	hex_dictionary.remove(hex_unit)
	GlobalServices.node_pool.return_node("hex_node", hex_node)

func build_map():
	build_tile(HexUnit.ZERO)
	for neighbor in HexUtilities.get_all_neighbors(HexUnit.ZERO):
		build_tile(neighbor)
	
