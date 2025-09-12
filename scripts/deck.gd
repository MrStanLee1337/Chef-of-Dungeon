extends Node2D

@export var myCardContainer: Node
@export var targetCardContainer: Node

var myCards: Array = []

func _ready() -> void:
	for child in myCardContainer.get_children():
		if child is Card:
			child.set_hidden_in_deck(true)
			child.get_parent().remove_child(child)
			myCards.append(child)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var card = myCards[0]
		card.set_hidden_in_deck(false)
		targetCardContainer.add_child(card)
		myCards.erase(card)
		if myCards.size() == 0:
			self.queue_free()
