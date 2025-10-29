class_name CookingMethod extends Resource


@export_multiline var info: String
@export var texture: Texture2D
var description: String:
	get:
		return resource_name + "Description"
