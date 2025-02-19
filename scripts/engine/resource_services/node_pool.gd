#Manages PackedScenes that need to be instantiated in bulk
const DEFAULT_POOL_SIZE = 50

var _pools : Dictionary

#Register and instantiate a packed scene, type is the identifier
func register_node(type : String, scene : PackedScene, count : int = DEFAULT_POOL_SIZE) -> bool:
	if !_pools.has(type) && scene != null:
		var pool = Pool.new()
		for i in count:
			pool.array.append(scene.instantiate())
		_pools[type] = pool
		return true
	push_error("Can't register node")
	return false
	
#Retrieve a registered packed scene node
func retrieve_node(type : String) -> Node:
	var pool
	if _pools.has(type):
		pool = _pools[type]
	if pool != null && pool.array.size() > 0:
		var node = pool.array.pop_front()
		#var parent = node.get_parent() as Node
		#if parent != null:
			#parent.remove_child(node)
		return node
	push_error("Can't retrieve node")
	return null

#Return a node to the pool
func return_node(type : String, node : Node) -> bool:
	var pool = _pools[type] as Pool
	if pool != null && node != null:
		var parent = node.get_parent()
		if parent != null:
			parent.remove_child(node)
		pool.array.append(node)
		return true
	push_error("Can't return node")
	return false


func _test_pool():
	var result = register_node("test", PackedScene.new(), 10)
	if result == true:
		print("Register OK")
		var retrieve = retrieve_node("test")
		if retrieve != null:
			print("Retrieve OK")
			result = return_node("test", retrieve)
			if result == true:
				print("Return OK")
			else:
				print("Return Failed")
		else:
			print("Retrive Failed")
	else:
		print("Register Failed")


class Pool:
	var array : Array[Node] = []
