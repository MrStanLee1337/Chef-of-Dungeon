extends Node2D

class_name Card

var _isHiddenInDeck: bool = false
@export var canBeEaten: bool
@export var sustanance: int
var onCounter: bool = false
@export var isVegetable: bool = false

func set_hidden_in_deck(inDeck: bool) -> void:
	_isHiddenInDeck = inDeck
	visible = not inDeck

func get_hidden_in_deck() -> bool:
	return _isHiddenInDeck

func raise() -> void:
	find_child("MainSprite").position.y -= 10

func lower()-> void:
	find_child("MainSprite").position.y += 10

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# find LevelManager by name
	var levelManager = get_tree().get_root().get_node("Level/LevelManager") as LevelManager
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		levelManager.try_select(self)
		
	
