class_name ListSelecContainer extends Container


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

	_on_slot_select(get_child(0) as Slot)


func clear_slots() -> void:
	for slot in get_children():
		if slot is Slot:
			slot.queue_free()


func _create_slot(resource: Resource) -> void:
	var slot_instance: Slot = slot.instantiate() as Slot
	add_child(slot_instance)
	slot_instance.setup(resource)
	slot_instance.slot_select.connect(_on_slot_select)
	slot_instance.slot_confirm.connect(_on_slot_confirm)


func _on_slot_select(_slot: Slot) -> void:
	_select_slot = _slot
	res_changed.emit()


func _on_slot_confirm(_slot: Slot) -> void:
	_select_slot = _slot
	res_changed.emit()
	confirm.emit()
