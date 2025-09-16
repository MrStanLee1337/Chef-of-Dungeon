extends Node2D

class_name Deck

@export var _targetCardContainer: Node

var _myCards: Array = []

func _ready() -> void:
	var globalDeck = Global.currentDeck
	var globalCardPath = Global.cardsPath
	for cardId in globalDeck.keys():
		var cardScene : PackedScene = load(globalCardPath[cardId])
		for i in range(globalDeck[cardId]):
			var cardNode = cardScene.instantiate()
			cardNode.set_hidden_in_deck(true)
			#_myCardContainer.add_child(cardNode)
			_myCards.append(cardNode)
	_myCards.shuffle()
	#for child in _myCardContainer.get_children():
		#if child is Card:
			#child.set_hidden_in_deck(true)
			#_myCards.append(child)
			#child.get_parent().remove_child(child)

func draw_card() -> void:
	if _myCards.size() == 0:
		return
	var card = _myCards[0]
	_targetCardContainer.add_child(card)
	card.set_hidden_in_deck(false)
	_myCards.erase(card)
