# Stack of undoable game commands
#class_name CommandStack

var _array : Array[TileCommandBase] = []


func push(command : TileCommandBase):
	_array.push_front(command)
	
func peek() -> TileCommandBase:
	return _array.front()
	
func pop() -> TileCommandBase:
	return _array.pop_front()
	
func size() -> int:
	return _array.size()

func clear() -> void:
	_array.clear()
