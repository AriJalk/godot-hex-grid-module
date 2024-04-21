extends Node3D
class_name GameManager

@export_range(0.1, 10, 0.1) var _camera_speed : float = 5

const CommandStack = preload("res://Scripts/HexSystem/TileCommands/command_stack.gd")
const AddCommand = preload("res://Scripts/HexSystem/TileCommands/add_command.gd")
const RemoveCommand = preload("res://Scripts/HexSystem/TileCommands/remove_command.gd")

static var game_resources = {
	HexTile: "hex_tile",
	HexSlot: "hex_slot",
	}

@export var _ui : UserInterface
@export var _hex_grid : Node3D
@export var _camera : Camera3D

var _node_pool : NodePool
var _input_manager
var _tile_manager : TileManager

var _placement_tile
var _last_hex : Hex
var _delta = 0


var _command_stack

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# initialize node pool and resources
	_node_pool = ServiceLocator.node_pool
	var tile_scene = preload("res://Scripts/MapElements/Hex/hex_tile.tscn")
	_node_pool.register_node(game_resources[HexTile], tile_scene, 300)
	var collision_scene = preload("res://Scripts/MapElements/Hex/hex_slot.tscn")
	_node_pool.register_node(game_resources[HexSlot], collision_scene, 300)
	
	# initialize input manager and register signals
	_input_manager = preload("res://Scripts/Engine/input_manager.gd").new()
	add_child(_input_manager)
	_input_manager.mouse_pressed.connect(_mouse_pressed)
	_input_manager.mouse_moved.connect(_mouse_moved)
	_input_manager.key_movement.connect(_camera_moved)
	
	# initialize placement tile
	_placement_tile = _hex_grid.get_node("PlacementTile") as Node3D
	var tile_object = _node_pool.retrieve_node(game_resources[HexTile])
	_hex_grid.remove_child(_placement_tile)
	
	# initialize ui
	_ui.undo_button.pressed.connect(_undo)
	
	_initialize_game()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_delta = delta


		
	
func _exit_tree() -> void:
	_input_manager.mouse_pressed.disconnect(_mouse_pressed)
	_input_manager.mouse_moved.disconnect(_mouse_moved)
	_input_manager.key_movement.disconnect(_camera_moved)
	_ui.undo_button.pressed.disconnect(_undo)
	
func _initialize_game() -> void:
	# initialize tile manager
	_tile_manager = TileManager.new(_hex_grid)
	# initialize origin hex and slot
	var hex = Hex.ZERO
	hex.can_be_removed = false
	var slot = _tile_manager.add_slot(hex)
	_tile_manager.add_tile(hex)
	# set placement tile to initial position
	var placement_slot = _tile_manager.get_slot(HexUtilities.hex_neighbor(hex, HexUtilities.HexDirections.SOUTH))
	placement_slot.add_child(_placement_tile)
	_placement_tile.hex = placement_slot.hex_data
	
	# initialize command stack
	_command_stack = CommandStack.new()

func _camera_moved(camera_translation: Vector2) -> void:
	var movement_vector = Vector3(camera_translation.x, 0, camera_translation.y) * _camera_speed * _delta
	var new_position = _camera.transform.origin + movement_vector
	
	# Clamp the camera position to stay within the bounds
	new_position.x = clamp(new_position.x, _tile_manager.min_x, _tile_manager.max_x)
	new_position.z = clamp(new_position.z, _tile_manager.min_z + 1.5, _tile_manager.max_z + 1.5)
	
	_camera.transform.origin = new_position

func _mouse_moved(mouse_position : Vector2i) -> void:
	if _ui.is_mouse_over_button == false:
		# raycast from mouse position and check if hit a hex slot
		var result = _raycast(mouse_position, 1<<1)
		if result != null:
			var slot = result.get_parent() as HexSlot
			if slot != null && slot.hex_data != _last_hex:
				_move_placement_tile(slot)
		else:
			_move_placement_tile()
			_last_hex = Hex.NULL

# moves the placement tile to a new slot
func _move_placement_tile(new_slot : HexSlot = null) -> void:
	if new_slot != null:
		# detach from parent
		var previous_parent = _placement_tile.get_parent()
		if previous_parent != null:
			previous_parent.remove_child(_placement_tile)
		# attach to new parent at slot
		_placement_tile.hex = new_slot.hex_data
		new_slot.add_child(_placement_tile)
		
		# reset position
		_placement_tile.transform.origin = Vector3(0, 0.1, 0)
		_last_hex = new_slot.hex_data
	# remove placement tile if not pointing at slot
	if new_slot == null:
		var previous_parent = _placement_tile.get_parent()
		if previous_parent != null:
			previous_parent.remove_child(_placement_tile) 

# todo: change signal to removve position
func _mouse_pressed(mouse_position : Vector2i, button : int) -> void:
	if !_placement_tile.hex.equals(Hex.NULL) && _ui.is_mouse_over_button == false:
		var slot = _placement_tile.get_parent() as HexSlot
		if slot != null:
			if button == MOUSE_BUTTON_LEFT:
				_tile_selected_func(slot)
			elif button == MOUSE_BUTTON_RIGHT:
				_tile_remove_func(slot)

func _tile_selected_func(slot : HexSlot):
	var command = AddCommand.new(slot, _tile_manager)
	if command.can_execute:
		command.execute()
		_command_stack.push(command)

func _tile_remove_func(slot : HexSlot):
	var command = RemoveCommand.new(slot, _tile_manager)
	if command.can_execute:
		command.execute()
		_command_stack.push(command)

func _raycast(mouse_position : Vector2, layer_mask: int) -> CollisionObject3D:
	# Get the mouse position in the viewport
	# Get the camera's ray origin and direction in world space
	var from = _camera.project_ray_origin(mouse_position)
	var to = _camera.project_ray_normal(mouse_position) * 100
	# Perform the raycast
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, from + to, layer_mask)
	var result = space_state.intersect_ray(query)
	
	# Check if a collision occurred
	if result.size() > 0:
		# Get the first collision object
		var collision = result["collider"]
		if collision is CollisionObject3D:
			return collision
	return null
	
func _undo() -> void:
	if _command_stack.size() > 0:
		var command = _command_stack.pop()
		if command != null:
			command.undo()
