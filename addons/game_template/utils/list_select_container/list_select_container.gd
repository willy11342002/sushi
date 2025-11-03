class_name ListSelectContainer extends Container


@export var allow_null: bool = false
@export var slot: PackedScene

signal confirm
signal res_changed()
var _select_slot: Slot
var resource: Resource:
	get:
		if _select_slot == null:
			return null
		return _select_slot.data
	set(value):
		for slot in get_children():
			if slot is not Slot:
				continue
			if slot.data == value:
				_select_slot = slot
				_select_slot.select()
				res_changed.emit()
				return


func create_slots(resources: Array) -> void:
	if allow_null:
		_create_slot(null)

	for resource in resources:
		_create_slot(resource)

	_on_slot_hover(get_child(0) as Slot)


func clear_slots() -> void:
	for slot in get_children():
		if slot is Slot:
			slot.queue_free()


func _create_slot(resource: Resource) -> void:
	var slot_instance: Slot = slot.instantiate() as Slot
	add_child(slot_instance)
	slot_instance.setup(resource)
	slot_instance.slot_hover.connect(_on_slot_hover)
	slot_instance.slot_left_click.connect(_on_slot_left_click)


func _on_slot_hover(_slot: Slot) -> void:
	_select_slot = _slot
	res_changed.emit()


func _on_slot_left_click(_slot: Slot) -> void:
	_select_slot = _slot
	res_changed.emit()
	confirm.emit()
