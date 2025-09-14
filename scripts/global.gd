extends Node

@export var currentDeck : Dictionary
@export var cardsPath : Dictionary

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
		"salad" : "res://scenes/cards/salad.tscn"
				}
	
