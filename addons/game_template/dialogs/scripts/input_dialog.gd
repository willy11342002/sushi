class_name InputDialog extends CanvasLayer


@export var input_field: LineEdit
@export var confirm_button: Button
@export var cancel_button: Button


func show_dialog(confirm :Callable, placeholder := "", confirm_button_text := "Confirm"):
	input_field.placeholder_text = placeholder
	input_field.grab_focus()

	confirm_button.text = confirm_button_text
	confirm_button.pressed.connect(func():
		if input_field.text != "":
			confirm.call(input_field.text)
		else:
			confirm.call(placeholder)
		queue_free()
	)
	cancel_button.pressed.connect(queue_free)
