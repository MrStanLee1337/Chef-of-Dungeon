extends Node

class Recipe:
	var ingredients: Array
	var result: String
	
	func _init(p_ingredients: Array, p_result: String):
		ingredients = p_ingredients
		result = p_result

@export var currentDeck : Dictionary
@export var cardsPath : Dictionary
@export var mix_recipes : Dictionary
@export var heat_recipes : Dictionary
@export var slice_recipes : Dictionary

func _ready() -> void:
	currentDeck = {
		"onion" : 3,
		"tomato" : 4,
		"carrot" : 2,
		"salad" : 1
	}
	
	cardsPath = {
		"onion" : "res://scenes/cards/onion.tscn",
		"tomato" : "res://scenes/cards/tomato.tscn",
		"carrot" : "res://scenes/cards/carrot.tscn",
		"sliced_onion" : "res://scenes/cards/sliced_onion.tscn",
		"sliced_tomato" : "res://scenes/cards/sliced_tomato.tscn",
		"sliced_carrot" : "res://scenes/cards/sliced_carrot.tscn",
		"roasted_carrot" : "res://scenes/cards/roasted_carrot.tscn",
		"roasted_tomato" : "res://scenes/cards/roasted_tomato.tscn",
		
		"salad" : "res://scenes/cards/salad.tscn"
	}
	
	mix_recipes = {
		"salad": Recipe.new(["tomato", "carrot", "onion"], "salad"),
		"vegetable_mix": Recipe.new(["onion", "carrot"], "vegetable_mix")
	}
	
	heat_recipes = {
		"roasted_carrot": Recipe.new(["carrot"], "roasted_carrot"),
		"roasted_tomato": Recipe.new(["tomato"], "roasted_tomato")
	}
	
	slice_recipes = {
		"sliced_tomato": Recipe.new(["tomato"], "sliced_tomato"),
		"sliced_onion": Recipe.new(["onion"], "sliced_onion")
	}

func check_recipe(ingredients: Array, recipe_dict: Dictionary) -> Recipe:
	ingredients.sort() # Sort to ensure consistent ordering
	for recipe_name in recipe_dict:
		var recipe = recipe_dict[recipe_name]
		var recipe_ingredients = recipe.ingredients.duplicate()
		recipe_ingredients.sort()
		if recipe_ingredients == ingredients:
			return recipe
	return null
