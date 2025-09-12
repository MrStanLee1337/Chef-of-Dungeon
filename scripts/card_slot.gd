extends Node2D

class_name CardSlot

func occupied() -> bool:
	return get_child_count() > 0

func _on_child_entered_tree(node: Node) -> void:
	if node is Card:
		if occupied():
			print("Error: CardSlot already occupied")
			return
		(node as Card).position = Vector2.ZERO
