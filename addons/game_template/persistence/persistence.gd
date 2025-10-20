extends Node2D

@export var data: SaveData
var config := ConfigFile.new()
var config_path = "user://settings.cfg"

signal input_map_changed

func save_data():
	for obj in get_tree().get_nodes_in_group("persistence"):
		if obj.has_method("dumps_data"):
			obj.dumps_data(data)

	data.save_to_disk()


func load():
	for obj in get_tree().get_nodes_in_group("persistence"):
		if obj.has_method("loads_data"):
			obj.loads_data(data)


func save_settings():
	config.save(config_path)


func load_settings():
	config.load(config_path)
	# Apply audio settings
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), config.get_value("audio", "Master", 1.0))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), config.get_value("audio", "BGM", 1.0))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), config.get_value("audio", "SFX", 1.0))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("UI"), config.get_value("audio", "UI", 1.0))

	# Apply video settings
	if config.get_value("video", "fullscreen", false):
		get_window().mode = Window.MODE_FULLSCREEN
	else:
		get_window().mode = Window.MODE_WINDOWED

	get_viewport().size = config.get_value("video", "resolution", Vector2i(640, 360))
	DisplayServer.window_set_size(get_viewport().size)

	# Apply input settings
	for action in InputMap.get_actions():
		if config.has_section_key("input", action):
			var saved_events = config.get_value("input", action, [])
			if saved_events.size() == 0:
				continue
			InputMap.action_erase_events(action)
			for event in saved_events:
				InputMap.action_add_event(action, event)


func _ready() -> void:
	if FileAccess.file_exists(config_path):
		load_settings()
