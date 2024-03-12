# Stack of undoable game commands
class_name CommandStack

var _array : Array[CommandBase] = []


func push(command : CommandBase):
	_array.push_front(command)
	
func peek() -> CommandBase:
	return _array.front()
	
func pop() -> CommandBase:
	return _array.pop_front()
	
func size() -> int:
	return _array.size()

func clear() -> void:
	_array.clear()
