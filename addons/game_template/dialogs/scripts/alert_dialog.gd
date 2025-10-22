class_name AlertDialog extends CanvasLayer


@export var message_label: Label
@export var confirm_button: Button


func show_dialog(confirm :Callable, message := "", confirm_button_text := "Confirm"):
	message_label.text = message

	confirm_button.text = confirm_button_text
	confirm_button.pressed.connect(func():
		confirm.call()
		queue_free()
	)
