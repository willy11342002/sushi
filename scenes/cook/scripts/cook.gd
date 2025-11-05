extends Node2D

@export var main_ingredient_container: Container
@export var secondary_ingredient_container: Container
@export var tag_container: Container
@export var slot_scene: PackedScene

@export var main_count_label_node: Label
@export var secondary_count_label_node: Label
@export var total_count_label_node: Label

signal res_changed

var offering: Offering
var _current_ingredient: Ingredient
var _current_tags: Array = []
var _current_tags_dic: Dictionary = _current_tags.reduce(
	func(dict, slot):
		dict[slot.data] = slot
		return dict,
	{},
)

func _ready() -> void:
	offering = Offering.new(Persistence.temp["sushi_type"])
	res_changed.emit()

	for ingredient in Persistence.data.ingredients:
		match ingredient.type:
			"Main":
				_create_slot(
					ingredient,
					main_ingredient_container,
					true,
				)
			"Secondary":
				_create_slot(
					ingredient,
					secondary_ingredient_container,
					true,
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


func _attribute_string(attribute: String) -> String:
	if offering == null:
		return tr(attribute.capitalize()) + ": 0"
	return tr(attribute.capitalize()) + ": " + str(int(offering.get(attribute).call()))


func _create_slot(resource: Resource, container: Container, _connect: bool = false) -> Slot:
	var slot: Slot = slot_scene.instantiate()
	container.add_child(slot)
	slot.setup(resource)

	if _connect:
		slot.slot_hover.connect(_on_preview_current)
		slot.slot_left_click.connect(_on_add_ingredient)
		slot.slot_right_click.connect(_on_remove_ingredient)

	return slot


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

	slot.count += 1
	offering.ingredients.append(slot.data)
	slot.data.on_upgrade(offering)
	res_changed.emit()

	for tag in slot.data.tags:
		tag.on_upgrade(offering)
		_on_add_tag(tag)


func _on_remove_ingredient(slot: Slot) -> void:
	if slot.count <= 0:
		return
	
	slot.count -= 1
	offering.ingredients.erase(slot.data)
	slot.data.on_downgrade(offering)
	res_changed.emit()

	for tag in slot.data.tags:
		tag.on_downgrade(offering)
		_on_remove_tag(tag)


func _on_add_tag(tag: Tag) -> void:
	if not _current_tags_dic.has(tag):
		_current_tags_dic[tag] = _create_slot(
			tag,
			tag_container,
		)
	_current_tags_dic[tag].count += 1


func _on_remove_tag(tag: Tag) -> void:
	if _current_tags_dic.has(tag):
		_current_tags_dic[tag].count -= 1
		if _current_tags_dic[tag].count <= 0:
			_current_tags_dic[tag].queue_free()
			_current_tags_dic.erase(tag)
