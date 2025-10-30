extends Node2D

@export var main_ingredient_container: VBoxContainer
@export var secondary_ingredient_container: VBoxContainer
@export var slot_scene: PackedScene

@export var main_count_label_node: Label
@export var secondary_count_label_node: Label
@export var total_count_label_node: Label

signal res_changed

var sushi_type: SushiType
var current_ingredient: Resource
var selected_ingredients: Array
var main_count_color: Color:
	get:
		var main_ingredients = selected_ingredients.filter(func(i): return i.type == "Main")
		if main_ingredients.size() >= sushi_type.main_ingredient_count:
			return Color.RED
		return Color.WHITE
var main_count_string: String:
	get:
		var main_ingredients = selected_ingredients.filter(func(i): return i.type == "Main")
		return tr("MainIngredient") + ": %d / %d" % [main_ingredients.size(), sushi_type.main_ingredient_count]
var secondary_count_color: Color:
	get:
		var secondary_ingredients = selected_ingredients.filter(func(i): return i.type == "Secondary")
		if secondary_ingredients.size() >= sushi_type.secondary_ingredient_count:
			return Color.RED
		return Color.WHITE
var secondary_count_string: String:
	get:
		var secondary_ingredients = selected_ingredients.filter(func(i): return i.type == "Secondary")
		return tr("SecondaryIngredient") + ": %d / %d" % [secondary_ingredients.size(), sushi_type.secondary_ingredient_count]
var total_count_color: Color:
	get:
		if selected_ingredients.size() >= sushi_type.total_ingredient_count:
			return Color.RED
		return Color.WHITE
var total_count_string: String:
	get:
		return tr("TotalIngredient") + ": %d / %d" % [selected_ingredients.size(), sushi_type.total_ingredient_count]


func _ready() -> void:
	sushi_type = Persistence.temp["sushi_type"]
	res_changed.emit()

	for ingredient in Persistence.data.ingredients:
		_create_slot(ingredient)


func _create_slot(ingredient: Ingredient) -> void:
	var slot: Slot = slot_scene.instantiate()
	
	match ingredient.type:
		"Main":
			main_ingredient_container.add_child(slot)
		"Secondary":
			secondary_ingredient_container.add_child(slot)
	
	slot.toggle_mode = true
	slot.text = ingredient.resource_name
	slot.setup(ingredient)
	slot.slot_select.connect(_on_preview_current)
	slot.slot_confirm.connect(_on_modify_ingredients)


func _on_preview_current(slot: Slot) -> void:
	current_ingredient = slot.data
	res_changed.emit()


func _on_modify_ingredients(slot: Slot) -> void:
	# Check ingredient count
	var main_ingredients = selected_ingredients.filter(func(i): return i.type == "Main")
	var secondary_ingredients = selected_ingredients.filter(func(i): return i.type == "Secondary")
	if slot.data.type == "Main" and main_ingredients.size() >= sushi_type.main_ingredient_count and not selected_ingredients.has(slot.data):
		slot.button_pressed = false
		await UtilsTween.shake(main_count_label_node, 5, 0.5)
		return
	elif slot.data.type == "Secondary" and secondary_ingredients.size() >= sushi_type.secondary_ingredient_count and not selected_ingredients.has(slot.data):
		slot.button_pressed = false
		await UtilsTween.shake(secondary_count_label_node, 5, 0.5)
		return
	elif selected_ingredients.size() >= sushi_type.total_ingredient_count and not selected_ingredients.has(slot.data):
		slot.button_pressed = false
		await UtilsTween.shake(total_count_label_node, 5, 0.5)
		return

	if slot.data not in selected_ingredients:
		selected_ingredients.append(slot.data)
		slot.button_pressed = true
	else:
		selected_ingredients.erase(slot.data)
		slot.button_pressed = false
	res_changed.emit()
