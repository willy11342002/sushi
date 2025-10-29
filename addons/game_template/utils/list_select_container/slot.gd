class_name Slot extends Button


@export var data: Resource

signal res_changed()
signal slot_select(slot: Slot)
signal slot_confirm(slot: Slot)

func setup(_data: Resource) -> void:
	data = _data
	res_changed.emit()

func select() -> void:
	slot_select.emit(self)

func confirm() -> void:
	slot_confirm.emit(self)
