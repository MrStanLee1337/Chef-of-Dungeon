extends Sprite2D

@export var _card_spacing: float = 100.0  # Maximum space between cards

var _myCards: Array[Card] = []
var _hand_width: float = 0.0

func _ready() -> void:
	_hand_width = region_rect.size.x

func _on_card_container_child_entered_tree(node: Node) -> void:
	if node is Card:
		_myCards.append(node)
		arrange_cards()
	
func _on_card_container_child_exiting_tree(node: Node) -> void:
	if node is Card:
		_myCards.erase(node)
		arrange_cards()

func arrange_cards() -> void:
	if _myCards.size() == 0:
		return
		
	# Get width of a single card (assuming all cards have same width)
	var collision_shape = _myCards[0].get_node("CollisionShape2D") as CollisionShape2D
	var rectangle_shape = collision_shape.shape as RectangleShape2D
	var card_width = rectangle_shape.size.x
	
	# Calculate spacing based on available width
	var total_cards_width = card_width * _myCards.size()
	var available_space = _hand_width - total_cards_width
	var current_spacing = min(_card_spacing, available_space / (_myCards.size() - 1)) if _myCards.size() > 1 else 0
	
	# Calculate start position to center the cards
	var total_width = total_cards_width + (current_spacing * (_myCards.size() - 1))
	var start_x = -total_width/2 + card_width/2
	
	# Position each card
	for i in range(_myCards.size()):
		var card = _myCards[i] as Card
		var target_pos = Vector2(start_x + (i * (card_width + current_spacing)), 0)
		card.position = target_pos
