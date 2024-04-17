#class_name HexDictionary

var hex_array : HexArray
var slot_dictionary = {}

func _init() -> void:
	hex_array = HexArray.new()
	
func add(hex_slot : HexSlot):
	var hex = hex_slot.hex_data
	var index = hex_array.get_index(hex)
	if index == -1:
		hex_array.add(hex)
		index = hex_array.get_last_index()
	#slot_dictionary.get_or_add(index)
	slot_dictionary[index] = hex_slot

func remove(hex_slot : HexSlot):
	var index = hex_array.get_index(hex_slot.hex_data)
	if index != -1:
		if slot_dictionary.has(index):
			slot_dictionary.erase(index)
			#hex_array.remove(hex_slot.hex_data)

func get_hex_slot(hex : Hex) -> HexSlot:
	var index = hex_array.get_index(hex)
	if index != -1:
		return slot_dictionary.get(index)
	return null

func contains(hex : Hex) -> bool:
	var index = hex_array.get_index(hex)
	if index != -1:
		return true
	return false
