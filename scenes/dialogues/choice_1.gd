extends Control

func _ready() -> void:
	$dialogue_manager.name__ = Global.playerName
	$dialogue_manager.start("dialogue")


func _on_dialogue_manager_made_choice(choice: String, message: String) -> void:
	if(choice == "Посмотреть"):
		$dialogue_manager.start("dialogue2")
		pass
