#Array of hexes to bypass the Array of Array type limitation
class_name HexArray

var array : Array[HexCoord] = []

func _init() -> void:
	pass

	
func get_index(hex : HexCoord) ->int:
	for i in array.size():
		if hex.equals(array[i]):
			return i
	return -1
	
func contains(hex : HexCoord) -> bool:
	for entry in array:
		if hex.equals(entry):
			return true
	return false

func add(hex : HexCoord) -> void:
	if hex != null:
		array.append(hex)

func remove(hex : HexCoord) -> void:
	if hex != null:
		var index = get_index(hex)
		if index != -1:
			array.remove_at(index)

func get_last_index() -> int:
	return array.size() - 1

func size() -> int:
	return array.size()
