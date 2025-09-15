extends Node

class_name LevelManager

var nowFeedingGuest: Guest = null
var selectedCards: Dictionary
@onready var targetCounter = get_tree().get_root().get_node("Level/Counter") as Node2D

func clear_selection() -> void:
	for card in selectedCards.keys():
		card.lower()
		selectedCards.erase(card)

func begin_feeding(guest: Guest) -> void:
	nowFeedingGuest = guest
	clear_selection()
	
func try_select(card: Card) -> void:
	if card in selectedCards.keys():
		card.lower()
		selectedCards.erase(card)
	else:
		card.raise()
		selectedCards[card] = "aboba"

func _unhandled_input(event: InputEvent) -> void:
	# HANDLE GUEST FEEDING, INTERCEPTS CLICK EVENTS
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

func _counter_has_vacant_spots_or_selected_card() -> bool:
		var hasSlot: bool = targetCounter.has_vacant_spots()
		if not hasSlot:
			for card in selectedCards:
				if card.onTable:
					hasSlot = true
		return hasSlot

func _on_mix_button_pressed() -> void:
	if not _counter_has_vacant_spots_or_selected_card():
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
			var saladNode : Card = preload("res://scenes/cards/salad.tscn").instantiate()
			saladNode.sustanance = sustananceSum
			targetCounter.add_child(saladNode)
	clear_selection()

func _on_heat_button_pressed() -> void:
	pass # Replace with function body.

func _on_slice_button_pressed() -> void:
	pass # Replace with function body.
