class_name FullScreenButton extends CheckButton


func _toggled(_pressed: bool) -> void:
	var win: Window = get_window()
	if _pressed:
		win.mode = Window.MODE_FULLSCREEN
	else:
		win.mode = Window.MODE_WINDOWED
	Persistence.config.set_value("video", "fullscreen", _pressed)

func _ready() -> void:
	button_pressed = Persistence.config.get_value("video", "fullscreen", false)
