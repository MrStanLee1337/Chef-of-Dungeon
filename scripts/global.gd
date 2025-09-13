extends Node

@export var currentDeck : Dictionary
@export var cardsPath : Dictionary

func _ready() -> void:
	currentDeck = {
		"sample" : 3,
		"sample2" : 4
	}
	
	cardsPath = {
		"sample" : "res://scenes/cards/SampleCard.tscn",
		"sample2" : "res://scenes/cards/SampleCard2.tscn"
	}
