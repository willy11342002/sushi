extends CanvasLayer

@export_file var prev_scene: String


func _on_exit_button_up() -> void:
	Persistence.save_settings()
	if prev_scene == "":
		queue_free()
	else:
		SceneManager.change_scene(prev_scene, "fade")
