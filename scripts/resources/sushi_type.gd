class_name SushiType extends Resource


@export var texture: Texture2D
@export_multiline var info: String

@export var main_ingredient_count: int = 1
@export var secondary_ingredient_count: int = 1
@export var total_ingredient_count: int = 1

@export_group("Quality")
@export var appearance: float = 1.0
@export var aroma: float = 1.0
@export var taste: float = 1.0

@export_group("Price")
@export var appearance_weight: float = 1.0
@export var aroma_weight: float = 1.0
@export var taste_weight: float = 1.0

@export_group("Complexity")
@export var complexity: float = 1.0

var description: String:
	get:
		return resource_name + "Description"
