extends Area2D

class_name Guest

var levelManager: LevelManager
@export var mySprite: Sprite2D
@export var hungryness: int
@onready var myLabel : Label = $Sprite2D/Label

func _ready() -> void:
	myLabel.text = str(hungryness)
	levelManager = get_tree().get_root().get_node("Level/LevelManager") as LevelManager
	

func feed(sustanance: int):
	hungryness -= sustanance
	if hungryness <= 0:
		queue_free()
	myLabel.text = str(hungryness)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		levelManager.beginFeeding(self)

func _process(_delta: float) -> void:
	if levelManager.nowFeedingGuest == self:
		mySprite.position.y = -10
	else:
		mySprite.position.y = 0
