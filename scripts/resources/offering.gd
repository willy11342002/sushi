class_name Offering extends Resource


@export var sushi_type: SushiType
@export var ingredients: Array[Ingredient] = []


func _init(_sushi_type: SushiType) -> void:
	sushi_type = _sushi_type

#region Appearance
func appearance() -> float:
	return base_appearance() * appearance_multiple()

func appearance_multiple() -> float:
	return sushi_type.appearance_multiple

func base_appearance() -> float:
	var _appearance: float = 0.0
	for ingredient in ingredients:
		_appearance += ingredient.appearance
	return _appearance
#endregion


#region Aroma
func aroma() -> float:
	return base_aroma() * aroma_multiple()

func aroma_multiple() -> float:
	return sushi_type.aroma_multiple

func base_aroma() -> float:
	var _aroma: float = 0.0
	for ingredient in ingredients:
		_aroma += ingredient.aroma
	return _aroma
#endregion

#region Taste
func taste() -> float:
	return base_taste() * taste_multiple()

func taste_multiple() -> float:
	return sushi_type.taste_multiple

func base_taste() -> float:
	var _taste: float = 0.0
	for ingredient in ingredients:
		_taste += ingredient.taste
	return _taste
#endregion

#region Price
func price() -> float:
	return base_price() * price_multiple()

func price_multiple() -> float:
	return sushi_type.price_multiple

func base_price() -> float:
	var _price: float = 0.0
	for ingredient in ingredients:
		_price += (
			ingredient.appearance * sushi_type.appearance_weight +
			ingredient.aroma * sushi_type.aroma_weight +
			ingredient.taste * sushi_type.taste_weight
		)
	return _price
#endregion

#region Complexity
func complexity() -> float:
	return base_complexity() * complexity_multiple()

func complexity_multiple() -> float:
	return sushi_type.complexity_multiple

func base_complexity() -> float:
	var _complexity: float = 0.0
	for ingredient in ingredients:
		_complexity += ingredient.complexity
	return _complexity
#endregion
