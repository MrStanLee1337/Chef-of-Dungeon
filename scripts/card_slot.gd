extends Node2D

class_name CardSlot

func occupied() -> bool:
	for child in get_children():
		if child is Card:
			return true
	return false

func _on_child_entered_tree(node: Node) -> void:
	if node is Card:
		(node as Card).position = Vector2.ZERO
