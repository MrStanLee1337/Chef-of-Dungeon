extends Node2D

class_name PlayerPawn


@export var current_node : MapGraphNode
@export var move_speed: float = 200.0 # скорость перемещения

var is_moving: bool = false

func _ready() -> void:
	if Global.current_node != "":
		print(Global.current_node)
		current_node = get_tree().root.get_node(Global.current_node)
	global_position = current_node.global_position
	
	
func move_to_node(to : MapGraphNode) -> void:
	if is_moving:
		return
	if to in current_node.connected_nodes:
		is_moving = true
		
		var tween = create_tween()
		tween.tween_property(self, "global_position", to.global_position, 
			global_position.distance_to(to.global_position) / move_speed)
		tween.tween_callback(_on_move_completed)
		current_node = to
		print(current_node.name)
		Global.current_node = current_node.get_path()
		
		
func _on_move_completed() -> void:
	is_moving = false
	if current_node.dialogue_path != null:
		if current_node.after_level_path == null:
			current_node.after_level_path = ""
		LevelLoader.start_auto_dialog(current_node.dialogue_path, current_node.after_level_path)
