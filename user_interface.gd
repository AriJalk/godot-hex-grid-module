extends CanvasLayer
class_name UserInterface

@export var undo_button : Button

var is_mouse_over_button : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	undo_button.mouse_entered.connect(mouse_entered_button)
	undo_button.mouse_exited.connect(mouse_exited_button)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _exit_tree() -> void:
	undo_button.mouse_entered.disconnect(mouse_entered_button)
	undo_button.mouse_exited.disconnect(mouse_exited_button)
	
func mouse_entered_button() -> void:
	is_mouse_over_button = true
	
func mouse_exited_button() -> void:
	is_mouse_over_button = false
