extends Node

class_name LevelManager

var nowFeedingGuest: Guest = null
var selectedCards: Dictionary

func begin_feeding(guest: Guest) -> void:
	nowFeedingGuest = guest
	selectedCards.clear()

func try_select(card: Card) -> void:
	if card in selectedCards.keys():
		card.lower()
		selectedCards.erase(card)
	else:
		card.raise()
		selectedCards[card] = "aboba"

func _unhandled_input(event: InputEvent) -> void:
	if nowFeedingGuest != null and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mousePos = get_viewport().get_mouse_position()
		var spaceState = get_viewport().get_world_2d().direct_space_state
		
		# Use intersect_point instead of intersect_ray for mouse picking
		var query = PhysicsPointQueryParameters2D.new()
		query.position = mousePos
		query.collide_with_areas = true
		var result = spaceState.intersect_point(query)
		
		print("Point query result: ", result) # Debug print

		# The result of intersect_point is an array of overlapping objects
		if result:
			for res in result:
				if res.collider is Card:
					var card = res.collider as Card
					if card.canBeEaten:
						nowFeedingGuest.feed(card.sustanance)
						card.queue_free()
					nowFeedingGuest = null # Reset after feeding
					get_viewport().set_input_as_handled()
					return

		# If no card was clicked, cancel feeding
		nowFeedingGuest = null
		print("Cancelled feeding guest")
		get_viewport().set_input_as_handled()

func freeIngridients() -> void:
	selectedCards

func _on_mix_button_pressed() -> void:
	var counter = get_tree().get_root().get_node("Level/Counter")
	var hasSlot: bool = counter.has_vacant_spots()
	if not hasSlot:
		for card in selectedCards:
			if card.onTable:
				hasSlot = true
	if not hasSlot:
		pass
	
	if selectedCards.size() >= 3:
		var isSalad : bool = true
		for card in selectedCards.keys():
			if not card.isVegetable:
				isSalad = false
		if isSalad:
			var sustananceSum : int = 4
			for card in selectedCards.keys():
				sustananceSum += card.sustanance
				card.queue_free()
			selectedCards.clear()
			var saladNode : Card = preload("res://scenes/cards/salad.tscn").instantiate()
			saladNode.sustanance = sustananceSum
			counter.add_child(saladNode)
	
