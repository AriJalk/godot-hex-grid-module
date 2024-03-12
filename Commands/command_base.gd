# Base class for a game command
class_name CommandBase

var can_execute : bool
var has_executed : bool

func execute() -> void:
	pass

func undo() -> void:
	pass
