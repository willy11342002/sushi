class_name Offering extends Resource


@export var sushi_type: SushiType
@export var ingredients: Array[Ingredient] = []


func _init(_sushi_type: SushiType) -> void:
	sushi_type = _sushi_type


func appearance() -> float:
	var _appearance: float = 0.0
	for ingredient in ingredients:
		_appearance += ingredient.appearance
	return _appearance

func aroma() -> float:
	var _aroma: float = 0.0
	for ingredient in ingredients:
		_aroma += ingredient.aroma
	return _aroma

func taste() -> float:
	var _taste: float = 0.0
	for ingredient in ingredients:
		_taste += ingredient.taste
	return _taste


func price() -> float:
	return 0.0


func complexity() -> float:
	return 0.0
