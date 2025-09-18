extends Control


func _ready() -> void:
	$dialogue_manager.name__ = Global.playerName
	$dialogue_manager.start("dialogue")
