class_name SushiTypeSlot extends MarginContainer


@export var sushi_type: SushiType
@export var hover_rect: Control

signal res_changed(res)
signal slot_select(slot: SushiTypeSlot)
signal slot_double_click(slot: SushiTypeSlot)


func setup(_sushi_type: SushiType) -> void:
	sushi_type = _sushi_type
	res_changed.emit(sushi_type)


func select() -> void:
	slot_select.emit(self)
	hover_rect.show()


func unselect() -> void:
	hover_rect.hide()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if event.double_click:
			slot_double_click.emit(self)
		else:
			select()
