class_name Offering extends Resource

@export var sushi_type: SushiType
@export var ingredients: Array[Ingredient] = []

var appearance: float:
	get:
		return ingredients.map(func (i): return i.appearance).reduce(func (a, b): return a + b, 0.0)
var aroma: float:
	get:
		return ingredients.map(func (i): return i.aroma).reduce(func (a, b): return a + b, 0.0)
var taste: float:
	get:
		return ingredients.map(func (i): return i.taste).reduce(func (a, b): return a + b, 0.0)
var price: float:
	get:
		return 0.0
var complexity: float:
	get:
		return 0.0

func _init(_sushi_type: SushiType) -> void:
	sushi_type = _sushi_type
