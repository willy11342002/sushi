class_name DescriptionResource extends Resource

var description: String:
	get:
		return resource_name + "Description"

func get_uid() -> int:
	return ResourceLoader.get_resource_uid(resource_path)

func get_uid_text() -> String:
	return ResourceUID.id_to_text(get_uid())
