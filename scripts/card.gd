extends Node2D

class_name Card

var _isHiddenInDeck: bool = false

func set_hidden_in_deck(inDeck: bool) -> void:
	_isHiddenInDeck = inDeck
	#visible = not inDeck

func get_hidden_in_deck() -> bool:
	return _isHiddenInDeck

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.
