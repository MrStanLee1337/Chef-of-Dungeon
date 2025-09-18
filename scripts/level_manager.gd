extends Node

class_name LevelManager

var nowFeedingGuest: Guest = null
var selectedCards: Dictionary
@onready var targetCounter = get_tree().get_root().get_node("Level/Counter") as Node2D
@onready var mixButton = get_tree().get_root().get_node("Level/MixButton") as Button
@onready var heatButton = get_tree().get_root().get_node("Level/HeatButton") as Button
@onready var sliceButton = get_tree().get_root().get_node("Level/SliceButton") as Button
@onready var deck = get_tree().get_root().get_node("Level/Deck") as Deck
@onready var guests = get_tree().get_root().get_node("Level/Guests") as Node2D
@export var perTurnCardBonuses: Array[int] = []
var currentTurn: int = 0

func _ready() -> void:
	selectedCards = {}
	mixButton.disabled = true
	heatButton.disabled = true
	sliceButton.disabled = true
	
func _process(delta: float) -> void:
	if guests.get_child_count() == 0:
		LevelLoader.load_global_map()

func _update_tool_buttons() -> void:
	var ingredients = []
	for card in selectedCards:
		ingredients.append(card.recipeName)
	
	var canMix = Global.check_recipe_mix(ingredients) != null
	var canHeat = Global.check_recipe(ingredients, Global.heat_recipes) != null
	var canSlice = Global.check_recipe(ingredients, Global.slice_recipes) != null
	
	mixButton.disabled = not canMix
	heatButton.disabled = not canHeat
	sliceButton.disabled = not canSlice

func clear_selection() -> void:
	for card in selectedCards.keys():
		card.lower()
		selectedCards.erase(card)
	_update_tool_buttons()

func begin_feeding(guest: Guest) -> void:
	if (guest.fedThisTurn):
		return
	nowFeedingGuest = guest
	clear_selection()

func try_select(card: Card) -> void:
	if card in selectedCards.keys():
		card.lower()
		selectedCards.erase(card)
	else:
		card.raise()
		selectedCards[card] = "aboba"
	_update_tool_buttons()

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
				if card.onCounter:
					hasSlot = true
		return hasSlot

func _process_recipe(recipe_type: Dictionary, mix : bool = false) -> void:
	if _counter_has_vacant_spots_or_selected_card() == false:
		clear_selection()
		return
	
	var ingredients = []
	for card in selectedCards:
		ingredients.append(card.recipeName)
	
	var recipe
	if mix:
		recipe = Global.check_recipe_mix(ingredients)
	else:
		recipe = Global.check_recipe(ingredients, recipe_type)
	if recipe:
		var add_sustanance = 0
		for card in selectedCards:
			add_sustanance += card.sustanance
			card.queue_free()
		clear_selection()
		if mix:
			spawn_result(recipe.result, add_sustanance)
		else:
			spawn_result(recipe.result, 0)

func _on_mix_button_pressed() -> void:
	_process_recipe(Global.mix_recipes, true)

func _on_heat_button_pressed() -> void:
	_process_recipe(Global.heat_recipes)

func _on_slice_button_pressed() -> void:
	_process_recipe(Global.slice_recipes)

func spawn_result(recipe_name: String, add_sustanance : int) -> void:
		var card_scene = load(Global.cardsPath[recipe_name])
		var card = card_scene.instantiate()
		card.sustanance += add_sustanance
		card.onCounter = true
		targetCounter.add_child(card)

func _on_skip_button_pressed() -> void:
	if currentTurn < perTurnCardBonuses.size():
		for i in range(perTurnCardBonuses[currentTurn]):
			deck.draw_card()
	# otherwise use last element of perTurnCardBonuses
	else: 
		for i in range(perTurnCardBonuses[perTurnCardBonuses.size() - 1]):
			deck.draw_card()
	currentTurn += 1
