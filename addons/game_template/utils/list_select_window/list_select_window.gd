class_name ListSelectWindow extends Control


@export var slot: PackedScene
@export var slot_container: Node
@export var loader: ResourcePreloader

signal confirm
signal res_changed(res)
var _select_slot: Slot

func _ready() -> void:
	for res_name in loader.get_resource_list():
		var resource: Resource = loader.get_resource(res_name)
		print(res_name, resource.resource_name)
		var slot_instance: Slot = slot.instantiate() as Slot
		slot_container.add_child(slot_instance)
		slot_instance.setup(resource)
		slot_instance.slot_select.connect(_on_slot_select)
		slot_instance.slot_double_click.connect(func(s):
			_on_slot_select(s)
			_on_confirm_button_pressed()
		)


func _on_slot_select(_slot: Slot) -> void:
	if _select_slot != null:
		_select_slot.unselect()

	_select_slot = _slot
	res_changed.emit(_select_slot.data)


func _on_confirm_button_pressed() -> void:
	confirm.emit()
	hide()

func _on_cancel_button_pressed() -> void:
	hide()
