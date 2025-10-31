extends Node2D

@export var main_ingredient_container: VBoxContainer
@export var secondary_ingredient_container: VBoxContainer
@export var slot_scene: PackedScene

@export var main_count_label_node: Label
@export var secondary_count_label_node: Label
@export var total_count_label_node: Label
@export var current_ingredients: Container

signal res_changed

var sushi_type: SushiType
var _current_ingredient: Resource
var _selected_ingredients: Array

var main_count_color: Color:
	get:
		var main_ingredients = _selected_ingredients.filter(func(i): return i.type == "Main")
		if sushi_type == null:
			return Color.WHITE
		if main_ingredients.size() >= sushi_type.main_ingredient_count:
			return Color.RED
		return Color.WHITE
var main_count_string: String:
	get:
		if sushi_type == null:
			return tr("MainIngredient") + ": 0 / 0"
		var main_ingredients = _selected_ingredients.filter(func(i): return i.type == "Main")
		return tr("MainIngredient") + ": %d / %d" % [main_ingredients.size(), sushi_type.main_ingredient_count]
var secondary_count_color: Color:
	get:
		if sushi_type == null:
			return Color.WHITE
		var secondary_ingredients = _selected_ingredients.filter(func(i): return i.type == "Secondary")
		if secondary_ingredients.size() >= sushi_type.secondary_ingredient_count:
			return Color.RED
		return Color.WHITE
var secondary_count_string: String:
	get:
		if sushi_type == null:
			return tr("SecondaryIngredient") + ": 0 / 0"
		var secondary_ingredients = _selected_ingredients.filter(func(i): return i.type == "Secondary")
		return tr("SecondaryIngredient") + ": %d / %d" % [secondary_ingredients.size(), sushi_type.secondary_ingredient_count]
var total_count_color: Color:
	get:
		if sushi_type == null:
			return Color.WHITE
		if _selected_ingredients.size() >= sushi_type.total_ingredient_count:
			return Color.RED
		return Color.WHITE
var total_count_string: String:
	get:
		if sushi_type == null:
			return tr("TotalIngredient") + ": 0 / 0"
		return tr("TotalIngredient") + ": %d / %d" % [_selected_ingredients.size(), sushi_type.total_ingredient_count]

var appearance: float:
	get:
		return _selected_ingredients.map(func (i): return i.appearance).reduce(func (a, b): return a + b, 0.0)
var aroma: float:
	get:
		return _selected_ingredients.map(func (i): return i.aroma).reduce(func (a, b): return a + b, 0.0)
var taste: float:
	get:
		return _selected_ingredients.map(func (i): return i.taste).reduce(func (a, b): return a + b, 0.0)
var price: float:
	get:
		return 0.0
var complexity: float:
	get:
		return 0.0

func _ready() -> void:
	sushi_type = Persistence.temp["sushi_type"]
	res_changed.emit()

	for ingredient in Persistence.data.ingredients:
		match ingredient.type:
			"Main":
				_create_slot(
					ingredient,
					main_ingredient_container,
					_on_preview_current,
					_on_add_ingredient
				)
			"Secondary":
				_create_slot(
					ingredient,
					secondary_ingredient_container,
					_on_preview_current,
					_on_add_ingredient
				)


func _create_slot(ingredient: Ingredient, container: Container, select_callback = null, confirm_callback = null) -> void:
	var slot: Slot = slot_scene.instantiate()
	container.add_child(slot)
	slot.setup(ingredient)
	
	if select_callback != null:
		slot.slot_select.connect(select_callback)
	if confirm_callback != null:
		slot.slot_confirm.connect(confirm_callback)


func _on_preview_current(slot: Slot) -> void:
	_current_ingredient = slot.data
	res_changed.emit()


func _on_add_ingredient(slot: Slot) -> void:
	match slot.data.type:
		"Main":
			var main_ingredients = _selected_ingredients.filter(func(i): return i.type == "Main")
			if main_ingredients.size() >= sushi_type.main_ingredient_count:
				slot.button_pressed = false
				await UtilsTween.shake(main_count_label_node, 5, 0.5)
				return
		"Secondary":
			var secondary_ingredients = _selected_ingredients.filter(func(i): return i.type == "Secondary")
			if secondary_ingredients.size() >= sushi_type.secondary_ingredient_count:
				slot.button_pressed = false
				await UtilsTween.shake(secondary_count_label_node, 5, 0.5)
				return
		_:
			if _selected_ingredients.size() >= sushi_type.total_ingredient_count:
				slot.button_pressed = false
				await UtilsTween.shake(total_count_label_node, 5, 0.5)
				return

	_selected_ingredients.append(slot.data)
	res_changed.emit()

	_create_slot(
		slot.data,
		current_ingredients,
		null,
		_on_remove_ingredient
	)


func _on_remove_ingredient(slot: Slot) -> void:
	slot.queue_free()
	_selected_ingredients.erase(slot.data)
	res_changed.emit()
