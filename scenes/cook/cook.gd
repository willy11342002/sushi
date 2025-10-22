extends Node2D

@export_group("Sushi Type")
@export var sushi_type: SushiType
@export var sushi_type_title_button: Button
@export var sushi_type_choose_window: ListSelectWindow

@export_group("Ingredient")
@export var ingredient: Ingredient
@export var ingredient_title_button: Button
@export var ingredient_choose_window: ListSelectWindow

@export_group("Cooking Method")
@export var method: CookingMethod
@export var method_title_button: Button
@export var method_choose_window: ListSelectWindow

func _ready() -> void:
	sushi_type_title_button.text = sushi_type.resource_name
	sushi_type_title_button.icon = sushi_type.texture

	ingredient_title_button.text = ingredient.resource_name

	method_title_button.text = method.resource_name

func _on_sushi_type_choose_window_confirm() -> void:
	sushi_type = sushi_type_choose_window._select_slot.data
	sushi_type_title_button.text = sushi_type.resource_name
	sushi_type_title_button.icon = sushi_type.texture

func _on_ingredient_choose_window_confirm() -> void:
	ingredient = ingredient_choose_window._select_slot.data
	ingredient_title_button.text = ingredient.resource_name

func _on_method_choose_window_confirm() -> void:
	method = method_choose_window._select_slot.data
	method_title_button.text = method.resource_name
