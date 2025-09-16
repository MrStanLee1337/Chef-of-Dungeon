extends Node2D

class_name Card

var _isHiddenInDeck: bool = false
@export var recipeName: String
@export var canBeEaten: bool
@export var sustanance: int
@export var isVegetable: bool = false
var onCounter: bool = false
		
func set_hidden_in_deck(inDeck: bool) -> void:
	_isHiddenInDeck = inDeck
	visible = not inDeck

func get_hidden_in_deck() -> bool:
	return _isHiddenInDeck

func raise() -> void:
	find_child("MainSprite").y_offset -= 10

func lower()-> void:
	find_child("MainSprite").y_offset += 10

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mousePos = get_viewport().get_mouse_position()
		var spaceState = get_viewport().get_world_2d().direct_space_state
		var query = PhysicsPointQueryParameters2D.new()
		query.position = mousePos
		query.collide_with_areas = true
		var results = spaceState.intersect_point(query)
		
		# Find card with highest priority (z_index first, then sibling order)
		var best_priority = -999999999
		var topmost_card = null
		for result in results:
			if result.collider is Card:
				var card = result.collider as Card
				var z = int(card.z_index)
				var parent = card.get_parent()
				var sibling_index = 0
				if parent:
					# get_children() returns an Array; find() returns the index of the element
					var children = parent.get_children()
					sibling_index = children.find(card)
					if sibling_index == -1:
						sibling_index = 0
				# Build a priority number: higher z dominates; sibling_index breaks ties.
				var priority = z * 100000 + sibling_index
				if priority > best_priority:
					best_priority = priority
					topmost_card = card
		
		# Only handle input if we are the topmost card
		if topmost_card == self:
			var levelManager = get_tree().get_root().get_node("Level/LevelManager") as LevelManager
			levelManager.try_select(self)
			get_viewport().set_input_as_handled()
