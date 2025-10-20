extends CanvasLayer

@export_file var start_game_scene: String
@export_file var settings_scene: String


func _on_start_game_button_up() -> void:
	SceneManager.change_scene(start_game_scene)

func _on_settings_button_up() -> void:
	SceneManager.change_scene(settings_scene, "fade")


func _on_exit_button_up() -> void:
	get_tree().quit()
