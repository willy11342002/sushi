extends Node2D

@export var main_container: VBoxContainer
@export var secondary_container: VBoxContainer
@export var slot_scene: PackedScene

var current_ingredient: Resource
signal res_changed


func _ready() -> void:
	for ingredient in Persistence.data.ingredients:
		_create_slot(ingredient)


func _create_slot(ingredient: Ingredient) -> void:
	var slot: Slot = slot_scene.instantiate()
	
	match ingredient.type:
		"Main":
			main_container.add_child(slot)
		"Secondary":
			secondary_container.add_child(slot)
	
	slot.text = ingredient.resource_name
	slot.setup(ingredient)
	slot.slot_select.connect(_on_preview_current)

func _on_preview_current(slot: Slot) -> void:
	current_ingredient = slot.data
	res_changed.emit()
