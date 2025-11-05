class_name Ingredient extends Resource


@export_enum("Main", "Secondary") var type: String
@export var texture: Texture2D

@export var tags: Array[Tag] = []

@export var appearance: float = 1.0
@export var aroma: float = 1.0
@export var taste: float = 1.0
@export var price: float = 1.0
@export var complexity: float = 1.0


var description: String = resource_name + "Description"


func on_upgrade(offering: Offering) -> void:
	offering.base_appearance += appearance
	offering.base_aroma += aroma
	offering.base_taste += taste
	offering.base_price += price
	offering.base_complexity += complexity
	for tag in tags:
		tag.on_upgrade(offering)

func on_downgrade(offering: Offering) -> void:
	offering.base_appearance -= appearance
	offering.base_aroma -= aroma
	offering.base_taste -= taste
	offering.base_price -= price
	offering.base_complexity -= complexity
	for tag in tags:
		tag.on_downgrade(offering)
