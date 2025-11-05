class_name Offering extends Resource


@export var sushi_type: SushiType
@export var tags: Dictionary = {}
@export var ingredients: Array[Ingredient] = []

var base_appearance: float = 0.0
var base_aroma: float = 0.0
var base_taste: float = 0.0
var base_price: float = 0.0
var base_complexity: float = 0.0

var appearance_multiple: float = 1.0
var aroma_multiple: float = 1.0
var taste_multiple: float = 1.0
var price_multiple: float = 1.0
var complexity_multiple: float = 1.0


func _init(_sushi_type: SushiType) -> void:
	sushi_type = _sushi_type
	sushi_type.on_upgrade(self)

func appearance() -> float:
	return base_appearance * appearance_multiple

func aroma() -> float:
	return base_aroma * aroma_multiple

func taste() -> float:
	return base_taste * taste_multiple

func price() -> float:
	return base_price * price_multiple

func complexity() -> float:
	return base_complexity * complexity_multiple ** float(ingredients.size())
