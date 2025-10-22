class_name SushiType extends Resource

@export var texture: Texture2D
@export_multiline var info: String
var description: String:
	get:
		return resource_name + "Description"
