extends Node

class Recipe:
	var ingredients: Array
	var result: String
	
	func _init(p_ingredients: Array, p_result: String):
		ingredients = p_ingredients
		result = p_result

@onready var current_node : String = ""
var playerName : String = "Косипоша"
@export var currentDeck : Dictionary
@export var cardsPath : Dictionary
@export var mix_recipes : Dictionary
@export var heat_recipes : Dictionary
@export var slice_recipes : Dictionary

func _ready() -> void:
	currentDeck = {
		"apple" : 3,
		"cucumber" : 4,
		"dusa" : 2,
		"mushroom" : 1
	}
	
	cardsPath = {
		"apple" : "res://scenes/cards/apple/apple.tscn",
		"apple_c" : "res://scenes/cards/apple/apple_c.tscn",
		"apple_f" : "res://scenes/cards/apple/apple_f.tscn",
		"apple_fc" : "res://scenes/cards/apple/apple_fc.tscn",
		"cucumber" : "res://scenes/cards/cucumber/cucumber.tscn",
		"cucumber_c" : "res://scenes/cards/cucumber/cucumber_c.tscn",
		"cucumber_f" : "res://scenes/cards/cucumber/cucumber_f.tscn",
		"cucumber_fc" : "res://scenes/cards/cucumber/cucumber_fc.tscn",
		"dusa" : "res://scenes/cards/dusa/dusa.tscn",
		"dusa_c" : "res://scenes/cards/dusa/dusa_c.tscn",
		"dusa_f" : "res://scenes/cards/dusa/dusa_f.tscn",
		"dusa_fc" : "res://scenes/cards/dusa/dusa_fc.tscn",
		"mushroom" : "res://scenes/cards/mushroom/mushroom.tscn",
		"mushroom_c" : "res://scenes/cards/mushroom/mushroom_c.tscn",
		"mushroom_f" : "res://scenes/cards/mushroom/mushroom_f.tscn",
		"mushroom_fc" : "res://scenes/cards/mushroom/mushroom_fc.tscn",
		"ziga" : "res://scenes/cards/ziga/ziga.tscn",
		"ziga_c" : "res://scenes/cards/ziga/ziga_c.tscn",
		"ziga_f" : "res://scenes/cards/ziga/ziga_f.tscn",
		"ziga_fc" : "res://scenes/cards/ziga/ziga_fc.tscn",
		"luna" : "res://scenes/cards/luna/luna.tscn",
		"luna_c" : "res://scenes/cards/luna/luna_c.tscn",
		"luna_f" : "res://scenes/cards/luna/luna_f.tscn",
		"luna_fc" : "res://scenes/cards/luna/luna_fc.tscn",
		"mix2" : "res://scenes/cards/mix2.tscn",
		"mix3" : "res://scenes/cards/mix3.tscn",
	}

	mix_recipes = {

	}

	heat_recipes = {
		"apple_f" : Recipe.new(["apple"], "apple_f"),
		"apple_fc" : Recipe.new(["apple_c"], "apple_fc"),
		"cucumber_f" : Recipe.new(["cucumber"], "cucumber_f"),
		"cucumber_fc" : Recipe.new(["cucumber_c"], "cucumber_fc"),
		"dusa_f" : Recipe.new(["dusa"], "dusa_f"),
		"dusa_fc" : Recipe.new(["dusa_c"], "dusa_fc"),
		"mushroom_f" : Recipe.new(["mushroom"], "mushroom_f"),
		"mushroom_fc" : Recipe.new(["mushroom_c"], "mushroom_fc"),
		"ziga_f" : Recipe.new(["ziga"], "ziga_f"),
		"ziga_fc" : Recipe.new(["ziga_c"], "ziga_fc"),
		"luna_f" : Recipe.new(["luna"], "luna_f"),
		"luna_fc" : Recipe.new(["luna_c"], "luna_fc")
	}

	slice_recipes = {
		"apple_c" : Recipe.new(["apple"], "apple_c"),
		"apple_fc" : Recipe.new(["apple_f"], "apple_fc"),
		"cucumber_c" : Recipe.new(["cucumber"], "cucumber_c"),
		"cucumber_fc" : Recipe.new(["cucumber_f"], "cucumber_fc"),
		"dusa_c" : Recipe.new(["dusa"], "dusa_c"),
		"dusa_fc" : Recipe.new(["dusa_f"], "dusa_fc"),
		"mushroom_c" : Recipe.new(["mushroom"], "mushroom_c"),
		"mushroom_fc" : Recipe.new(["mushroom_f"], "mushroom_fc"),
		"ziga_c" : Recipe.new(["ziga"], "ziga_c"),
		"ziga_fc" : Recipe.new(["ziga_f"], "ziga_fc"),
		"luna_c" : Recipe.new(["luna"], "luna_c"),
		"luna_fc" : Recipe.new(["luna_f"], "luna_fc")
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
	
func has_duplicate_elements_with_suffixes(arr_orig: Array) -> bool:
	var arr = arr_orig.duplicate()
	# Создаем множество для хранения базовых имен (без суффиксов)
	var base_names = {}

	for item in arr:
		var base_name = item
		# Удаляем суффиксы если они есть
		if item.ends_with("_fc"):
			base_name = item.substr(0, item.length() - 3)
		elif item.ends_with("_f"):
			base_name = item.substr(0, item.length() - 2)
		elif item.ends_with("_c"):
			base_name = item.substr(0, item.length() - 2)
		# Проверяем, есть ли уже такое базовое имя
		if base_name == "mix2" or base_name == "mix3" or base_names.has(base_name):
			return true
		# Добавляем базовое имя в множество
		base_names[base_name] = true
	return false	


func check_recipe_mix(ingredients: Array) -> Recipe:
	if not has_duplicate_elements_with_suffixes(ingredients):
		if ingredients.size() == 2:
			return Recipe.new(["aboba1", "aboba2"], "mix2")
		if ingredients.size() == 3:
			return Recipe.new(["aboba1", "aboba2", "aboba3"], "mix3")
	return null
