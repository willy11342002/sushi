class_name SaveSlot extends Control

@export var title_label: Label
@export var last_updated_label: Label
@export var hover_rect: Control

signal res_changed(res)
signal slot_select(slot: SaveSlot)
signal slot_double_click(slot: SaveSlot)
var file_name: String
var modified_time: int
var full_path: String

func setup(_file_name: String, _modified_time: int, _full_path: String) -> void:
	full_path = _full_path
	file_name = _file_name
	modified_time = _modified_time
	res_changed.emit(self)


func select() -> void:
	slot_select.emit(self)
	hover_rect.show()

func unselect() -> void:
	hover_rect.hide()


func _format_title(file_name: String) -> String:
	return file_name.replace(".res", "")

func _format_time(unix_time: int) -> String:
	var time: String = Time.get_datetime_string_from_unix_time(unix_time)
	return tr("SaveDataModifiedTime").format({"time": time})


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if event.double_click:
			slot_double_click.emit(self)
		else:
			select()
