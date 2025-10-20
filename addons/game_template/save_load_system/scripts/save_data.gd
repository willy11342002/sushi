class_name SaveData extends Resource


@export var title := ""
@export var file_name := ""
@export var map_data := {}


static func create(_path: String, _title: String) -> SaveData:
	var data = SaveData.new()
	data.set_title(_path, _title)
	return data


func set_title(save_path: String, new_title: String) -> void:
	var base_title = new_title
	var counter = 0
	while FileAccess.file_exists(save_path + new_title + ".res"):
		counter += 1
		new_title = base_title + "_" + str(counter)
	title = new_title
	file_name = save_path + title + ".res"


func save_to_disk():
	ResourceSaver.save(self, self.file_name)
