class_name SushiTypeChooseWindow extends Control

@export_group("Scenes")
@export var sushi_type_slot: PackedScene
@export var next_scene: Node
@export var prev_scene: Node

@export_group("UI Elements")
@export var loader: ResourcePreloader
@export var sushi_types_container: Node
@export var texture_rect: TextureRect
@export var title_label: Label
@export var description_label: Label

signal confirm
var _select_slot: SushiTypeSlot


func _ready() -> void:
	for res_name in loader.get_resource_list():
		var resource: SushiType = loader.get_resource(res_name) as SushiType
		var slot: SushiTypeSlot = sushi_type_slot.instantiate() as SushiTypeSlot
		slot.set_sushi_type(resource)
		slot.slot_select.connect(_on_slot_select)
		slot.slot_double_click.connect(func(s):
			_on_slot_select(s)
			_on_confirm_button_pressed()
		)
		sushi_types_container.add_child(slot)


func _on_slot_select(slot: SushiTypeSlot) -> void:
	if _select_slot != null:
		_select_slot.unselect()

	_select_slot = slot

	texture_rect.texture = _select_slot.sushi_type.texture
	title_label.text = _select_slot.sushi_type.type_name
	description_label.text = _select_slot.sushi_type.description

func _on_confirm_button_pressed() -> void:
	confirm.emit()
	hide()

func _on_cancel_button_pressed() -> void:
	hide()
