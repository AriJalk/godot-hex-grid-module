# Command to add new tile in existing slot
extends CommandBase
class_name AddCommand

var _tile_manager : TileManager
var _hex_slot : HexSlot

func _init(hex_slot : HexSlot, tile_manager : TileManager) -> void:
	if hex_slot != null && hex_slot.hex_tile == null:
		_tile_manager = tile_manager
		_hex_slot = hex_slot
		can_execute = true
	
func execute() -> void:
	if can_execute == true:
		var tile = _tile_manager.add_tile(_hex_slot.hex_data, _hex_slot)
		if tile != null:
			has_executed = true
		
		
func undo() -> void:
	if has_executed == true:
		_tile_manager.remove_tile(_hex_slot.hex_data)
