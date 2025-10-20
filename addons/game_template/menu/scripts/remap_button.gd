extends Button
class_name RemapButton

@export var action: String


func _init():
	toggle_mode = true
	theme_type_variation = "RemapButton"
	Persistence.input_map_changed.connect(update_key_text)


func _ready():
	set_process_unhandled_input(false)
	update_key_text()


func _toggled(_button_pressed):
	set_process_unhandled_input(_button_pressed)
	if _button_pressed:
		text = "Awaiting Input ..."
		release_focus()
	else:
		grab_focus()


func _unhandled_input(event: InputEvent):
	if event is InputEventMouse:
		return
	if not event.pressed:
		return
	Persistence.input_map_changed.emit()
	button_pressed = false
	if event.keycode == KEY_ESCAPE:
		return
	var _events = InputMap.action_get_events(action)
	if _events.size() == 0:
		InputMap.action_add_event(action, event)
	else:
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
	Persistence.input_map_changed.emit()


func update_key_text():
	var _events = InputMap.action_get_events(action)
	if _events.size() > 0:
		text = "%s" % _events[0].as_text()
	else:
		text = ""
