class_name SushiType extends Resource


@export var texture: Texture2D
@export var complexity_multiple: float = 1.0

@export_group("Limits")
@export var main_ingredient_count: int = 1
@export var secondary_ingredient_count: int = 1
@export var total_ingredient_count: int = 1

@export_group("Quality")
@export var appearance_multiple: float = 1.0
@export var aroma_multiple: float = 1.0
@export var taste_multiple: float = 1.0

@export_group("Price")
@export var price_multiple: float = 1.0
@export var appearance_weight: float = 1.0
@export var aroma_weight: float = 1.0
@export var taste_weight: float = 1.0


var description: String = resource_name + "Description"


func on_upgrade(offering: Offering) -> void:
	offering.appearance_multiple = appearance_multiple
	offering.aroma_multiple = aroma_multiple
	offering.taste_multiple = taste_multiple
	offering.price_multiple = price_multiple
	offering.complexity_multiple = complexity_multiple

func _on_downgrade(offering: Offering) -> void:
	offering.appearance_multiple = 1.0
	offering.aroma_multiple = 1.0
	offering.taste_multiple = 1.0
	offering.price_multiple = 1.0
	offering.complexity_multiple = 1.0
