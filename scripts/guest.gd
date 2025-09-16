extends Area2D

class_name Guest

var levelManager: LevelManager
@export var mySprite: Sprite2D
@export var hungryness: int
@export var unfedPenalty: int = 1
@onready var myLabel : Label = $Sprite2D/Label
var fedThisTurn: bool = false

func _ready() -> void:
	myLabel.text = str(hungryness)
	levelManager = get_tree().get_root().get_node("Level/LevelManager") as LevelManager
	# subscribe to skip button
	var skipButton = get_tree().get_root().get_node("Level/SkipButton") as Button
	skipButton.pressed.connect(self.on_skip_button_pressed)

func feed(sustanance: int):
	hungryness -= sustanance
	if hungryness <= 0:
		queue_free()
	fedThisTurn = true
	myLabel.text = str(hungryness)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		levelManager.begin_feeding(self)

func _process(_delta: float) -> void:
	if levelManager.nowFeedingGuest == self:
		mySprite.position.y = -10
	else:
		mySprite.position.y = 0
	if fedThisTurn:
		mySprite.modulate = Color(1,1,1,0.5)
	else:
		mySprite.modulate = Color(1,1,1,1)

func on_skip_button_pressed() -> void:
	if not fedThisTurn:
		feed(-unfedPenalty)
	fedThisTurn = false
