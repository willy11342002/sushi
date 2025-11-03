class_name Slot extends Button


@export var data: Resource

signal res_changed()
signal slot_hover(slot: Slot)
signal slot_left_click(slot: Slot)
signal slot_right_click(slot: Slot)
signal slot_double_click(slot: Slot)

func setup(_data: Resource) -> void:
	data = _data
	res_changed.emit()

func select() -> void:
	slot_hover.emit(self)

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("A"):
		if event.double_click:
			slot_double_click.emit(self)
		else:
			slot_left_click.emit(self)
	elif event.is_action_pressed("B"):
		slot_right_click.emit(self)
