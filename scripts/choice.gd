extends Control



func _ready() -> void:
	$dialogue_manager.name_ = Global.playerName
	$dialogue_manager.start("dialogue")


func _on_dialogue_manager_made_choice(choice: String, message: String) -> void:
	pass
