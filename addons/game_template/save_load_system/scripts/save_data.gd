class_name SaveData extends Resource


@export var title: String = ""
@export var file_name: String = ""
@export var modified_time: int = 0


static func create(_path: String, _title: String) -> SaveData:
	var data = SaveData.new()
	data.set_title(_path, _title)
	data.modified_time = Time.get_unix_time_from_system()
	return data


func set_title(save_path: String, new_title: String) -> void:
	var base_title: String = new_title
	var counter: int = 0
	while FileAccess.file_exists(save_path + new_title + ".res"):
		counter += 1
		new_title = base_title + "_" + str(counter)
	title = new_title
	file_name = save_path + title + ".res"


func save_to_disk():
	ResourceSaver.save(self, self.file_name)
