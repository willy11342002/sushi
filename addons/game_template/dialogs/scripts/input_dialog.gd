class_name InputDialog extends Control


@export var input_field: LineEdit
@export var confirm_button: Button
@export var cancel_button: Button

var confirm_callback: Callable

func show_dialog(_confirm :Callable, placeholder := "", confirm_button_text := "UI_Confirm"):
	confirm_callback = _confirm
	input_field.placeholder_text = placeholder
	input_field.grab_focus()

	confirm_button.text = confirm_button_text
	confirm_button.pressed.connect(confirm)
	cancel_button.pressed.connect(queue_free)

func confirm(text: String = "") -> void:
	if input_field.text != "":
		confirm_callback.call(input_field.text)
	else:
		confirm_callback.call(input_field.placeholder_text)
	queue_free()
