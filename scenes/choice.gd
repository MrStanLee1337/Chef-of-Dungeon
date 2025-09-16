extends Control



func _ready() -> void:
	$dialogue_manager.start("dialogue")


func _on_dialogue_manager_made_choice(choice: String, message: String) -> void:
	pass # Replace with function body.
