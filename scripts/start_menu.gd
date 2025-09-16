extends Control


func _on_button_pressed() -> void:
	LevelLoader.load_level("tutorial")


func _on_button_2_pressed() -> void:
	get_tree().quit()
