class_name BaseComponent extends Node


@onready var player: Character = get_parent() as Character

signal res_changed


func _ready() -> void:
	player.add_component(self)
	player.res_changed.connect(_on_res_changed)

func _on_res_changed() -> void:
	res_changed.emit()
