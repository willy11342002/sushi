class_name SaveSlot extends Slot


var file_name: String
var modified_time: int
var full_path: String


func title():
	return file_name.replace(".res", "")


func last_updated():
	var time: String = Time.get_datetime_string_from_unix_time(modified_time)
	return tr("UI_SaveDataModifiedTime").format({"time": time})


func setup_from_file(_file_name: String, _modified_time: int, _full_path: String) -> void:
	full_path = _full_path
	file_name = _file_name
	modified_time = _modified_time
	res_changed.emit()
