extends Node2D

@export_group("Sushi Type")
@export var sushi_type: SushiType
@export var sushi_type_title_button: Button
@export var sushi_type_choose_window: SushiTypeChooseWindow


func _ready() -> void:
	sushi_type_title_button.text = sushi_type.type_name
	sushi_type_title_button.icon = sushi_type.texture


func _on_sushi_type_choose_window_confirm() -> void:
	sushi_type = sushi_type_choose_window._select_slot.sushi_type
	sushi_type_title_button.text = sushi_type.type_name
	sushi_type_title_button.icon = sushi_type.texture
