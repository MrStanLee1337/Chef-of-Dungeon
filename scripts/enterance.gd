extends Control


func _ready() -> void:
	$dialogue_manager.name_ = Global.playerName
	$dialogue_manager.start("dialogue")
