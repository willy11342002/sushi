extends Node2D


@export_file var prev_scene: String
@export_file var next_scene: String

@export var list_container: ListSelecContainer


func _on_exit_button_up() -> void:
	SceneManager.change_scene(prev_scene)

func _on_confirm_button_up() -> void:
	SceneManager.change_scene(next_scene)

func _ready() -> void:
	list_container.create_slots(Persistence.data.sushi_types)
