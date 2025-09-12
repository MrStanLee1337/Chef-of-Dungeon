extends Node2D

class_name PlayerPawn


@export var current_node : MapGraphNode


func _ready() -> void:
	global_position = current_node.global_position
	
	
func move_to_node(to : MapGraphNode) -> void:
	print(current_node.node_id)
	print(to.node_id)
	print("\n")
	if to in current_node.connected_nodes:
		print(current_node.global_position)
		current_node = to
		print(current_node.global_position)
		print("\n")
		global_position = current_node.global_position
