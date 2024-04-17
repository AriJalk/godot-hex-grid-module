#class_name RemoveCommand
# Remove tile from hex
extends TileCommandBase

var _tile_manager : TileManager
var _hex

func _init(hex_slot : HexSlot, tile_manager : TileManager) -> void:
	if hex_slot != null && hex_slot.hex_tile != null:
		_tile_manager = tile_manager
		_hex = hex_slot.hex_data.duplicate()
		can_execute = true
	
func execute() -> void:
	if can_execute == true:
		_tile_manager.remove_tile(_hex)
		has_executed = true

func undo() -> void:
	if has_executed == true:
		var slot = _tile_manager.get_slot(_hex)
		if slot == null:
			slot = _tile_manager.add_slot(_hex)
		_tile_manager.add_tile(_hex)
