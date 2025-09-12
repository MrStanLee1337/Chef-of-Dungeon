extends Node2D

class_name Card

var _isHiddenInDeck: bool = false

func set_hidden_in_deck(inDeck: bool) -> void:
	_isHiddenInDeck = inDeck
	visible = not inDeck

func get_hidden_in_deck() -> bool:
	return _isHiddenInDeck

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var counter = get_tree().get_root().get_node("Level/Counter")
		if counter:
			self.reparent(counter)
