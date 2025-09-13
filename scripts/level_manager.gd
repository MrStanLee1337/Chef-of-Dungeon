extends Node

class_name LevelManager

var nowFeedingGuest: Guest = null

func beginFeeding(guest: Guest) -> void:
	nowFeedingGuest = guest

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
					print("trying to feed card %s to guest %s" % [card.name, nowFeedingGuest.name])
					# Potentially add your feeding logic here and then return
					# For example: nowFeedingGuest.feed(card)
					nowFeedingGuest = null # Reset after feeding
					get_viewport().set_input_as_handled()
					return

		# If no card was clicked, cancel feeding
		nowFeedingGuest = null
		print("Cancelled feeding guest")
		get_viewport().set_input_as_handled()
