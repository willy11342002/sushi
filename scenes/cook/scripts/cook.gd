extends Node2D

@export var main_ingredient_container: VBoxContainer
@export var secondary_ingredient_container: VBoxContainer
@export var slot_scene: PackedScene

@export var main_count_label_node: Label
@export var secondary_count_label_node: Label
@export var total_count_label_node: Label
@export var current_ingredients: Container

signal res_changed

var offering: Offering
var _current_ingredient: Resource


func _ready() -> void:
	offering = Offering.new(Persistence.temp["sushi_type"])
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


func _count_color(type: String) -> Color:
	if offering == null:
		return Color.WHITE
	var _ingredients: Array
	var _limit: int
	match type:
		"Main":
			_ingredients = offering.ingredients.filter(func(i): return i.type == "Main")
			_limit = offering.sushi_type.main_ingredient_count
		"Secondary":
			_ingredients = offering.ingredients.filter(func(i): return i.type == "Secondary")
			_limit = offering.sushi_type.secondary_ingredient_count
		_:
			_ingredients = offering.ingredients
			_limit = offering.sushi_type.total_ingredient_count
	if _ingredients.size() >= _limit:
		return Color.RED
	return Color.WHITE


func _count_string(type: String) -> String:
	if offering == null:
		return tr("%sIngredient" % type) + ": 0 / 0"
	var _ingredients: Array
	var _limit: int
	match type:
		"Main":
			_ingredients = offering.ingredients.filter(func(i): return i.type == "Main")
			_limit = offering.sushi_type.main_ingredient_count
		"Secondary":
			_ingredients = offering.ingredients.filter(func(i): return i.type == "Secondary")
			_limit = offering.sushi_type.secondary_ingredient_count
		_:
			_ingredients = offering.ingredients
			_limit = offering.sushi_type.total_ingredient_count
	return "%s: %d / %d" % [tr("%sIngredient" % type), _ingredients.size(), _limit]


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
			var main_ingredients = offering.ingredients.filter(func(i): return i.type == "Main")
			if main_ingredients.size() >= offering.sushi_type.main_ingredient_count:
				await UtilsTween.shake(main_count_label_node, 5, 0.5)
				return
		"Secondary":
			var secondary_ingredients = offering.ingredients.filter(func(i): return i.type == "Secondary")
			if secondary_ingredients.size() >= offering.sushi_type.secondary_ingredient_count:
				await UtilsTween.shake(secondary_count_label_node, 5, 0.5)
				return
		_:
			if offering.ingredients.size() >= offering.sushi_type.total_ingredient_count:
				await UtilsTween.shake(total_count_label_node, 5, 0.5)
				return

	offering.ingredients.append(slot.data)
	res_changed.emit()

	_create_slot(
		slot.data,
		current_ingredients,
		null,
		_on_remove_ingredient
	)


func _on_remove_ingredient(slot: Slot) -> void:
	slot.queue_free()
	offering.ingredients.erase(slot.data)
	res_changed.emit()
