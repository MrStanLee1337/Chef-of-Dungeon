extends Node2D

class_name MapGraphNode

@export var node_id: String = "node_1"
@export var connected_nodes: Array[MapGraphNode] = [] 

var player : PlayerPawn

func _ready():
	player = get_tree().get_first_node_in_group("PlayerPawn")
	node_id = "node_%d" % get_index()
	var label = $Label
	if label:
		label.text = node_id


func _on_click_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		player.move_to_node(self)
