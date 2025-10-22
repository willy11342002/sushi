class_name Ingredient extends Resource


@export_multiline var info: String
var description: String:
	get:
		return resource_name + "Description"
