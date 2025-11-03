class_name Ingredient extends Resource


@export_enum("Main", "Secondary") var type: String
@export var texture: Texture2D
var description: String:
	get:
		return resource_name + "Description"


@export var appearance: float = 1.0
@export var aroma: float = 1.0
@export var taste: float = 1.0
@export var complexity: float = 1.0
