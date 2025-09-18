extends Node


var levels_config: Dictionary = {}
var current_level_id: String = ""

func _ready() -> void:
	load_levels_config()
	
	
func load_levels_config():
	var config_file = FileAccess.open("res://configs/levels.json", FileAccess.READ)
	if config_file:
		var json_text = config_file.get_as_text()
		config_file.close()
		
		var json = JSON.new()
		var error = json.parse(json_text)
		if error == OK:
			levels_config = json.data
			print("Level config loaded successfully")
		else:
			push_error("Failed to parse level config: " + json.get_error_message())
	else:
		push_error("Failed to load level config file")


func load_level(level_id: String):
	var level_data = levels_config[level_id]
	var scene_path = level_data["scene_path"]

	# Загружаем сцену
	var scene_resource = load(scene_path)
	if not scene_resource or not scene_resource is PackedScene:
		push_error("Failed to load scene: " + scene_path)
		return false

	# Очищаем текущую сцену
	var current_scene = get_tree().current_scene
	if current_scene:
		current_scene.queue_free()
	
	# Создаем новую сцену
	var new_scene = scene_resource.instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	if get_tree().root.get_node("Level") != null:
		for guest_path in levels_config[level_id]["guests"]:
			var guest_scene = (load(guest_path) as PackedScene).instantiate()
			new_scene.get_node("Guests").add_child(guest_scene)

	current_level_id = level_id

	# Запускаем авто-диалог если есть
	if level_data["auto_dialog"] != "":
		start_auto_dialog(level_data["auto_dialog"], "")
	return true

# Запуск авто-диалога
func start_auto_dialog(dialog_path: String, after_level_path: String):
	print(dialog_path)
	if dialog_path == null or dialog_path == "":
		pass
	var scene_resource = load(dialog_path)
	var new_scene = scene_resource.instantiate()
	
	get_tree().root.add_child(new_scene)
	await get_tree().process_frame
	var dialogue_manager = new_scene.get_node("dialogue_manager")
	dialogue_manager.dialog_completed.connect(_on_dialog_completed)
	dialogue_manager.after_level_path = after_level_path

func _on_dialog_completed(level_path : String):
	if level_path != "":
		load_main_level(level_path)

# Публичные методы для удобства
func load_global_map():
	return load_level("global_map")

func load_main_level(level_id: String):
	return load_level(level_id)
