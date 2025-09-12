extends Node2D

var _myslots: Array[CardSlot] = []

func _ready() -> void:
	# Collect all CardSlot children from CardSlotContainer
	var container = get_node("SlotContainer")
	for child in container.get_children():
		if child is CardSlot:
			_myslots.append(child)

func has_vacant_spots() -> bool:
	for slot in _myslots:
		if not slot.occupied():
			return true
	return false

func _on_child_entered_tree(node: Node) -> void:
	if node is Card and node.get_parent() == self:
		for slot in _myslots:
			if slot.occupied():
				continue
			node.get_parent().remove_child(node)
			slot.add_child(node)
			return
		print("Error: No vacant spots available in counter")
