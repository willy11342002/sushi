class_name SaveSlot extends Control

@export var title_label: Label
@export var last_updated_label: Label
@export var hover_rect: Control

signal slot_select(slot: SaveSlot)
var file_name: String
var modified_time: int
var full_path: String

func setup(_file_name: String, _modified_time: int, _full_path: String) -> void:
	title_label.text = _file_name.replace(".tres", "")
	last_updated_label.text = "Last Updated: " + Time.get_datetime_string_from_unix_time(_modified_time, true)

	full_path = _full_path
	file_name = _file_name
	modified_time = _modified_time

func select() -> void:
	slot_select.emit(self)
	hover_rect.show()

func unselect() -> void:
	hover_rect.hide()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		select()
