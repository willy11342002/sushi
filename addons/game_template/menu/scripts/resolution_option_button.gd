class_name ResolutionOptionButton extends OptionButton


var _res_list: Array[Vector2i]

func _ready():
	for i in item_count:
		var _text_array = get_item_text(i).split("x")
		var vec = Vector2i(_text_array[0].to_int(), _text_array[1].to_int())
		_res_list.append(vec)
	var current_resolution = Persistence.config.get_value("video", "resolution", _res_list[0])
	select(_res_list.find(current_resolution))

	item_selected.connect(_on_item_selected)


func _on_item_selected(index: int) -> void:
	get_viewport().size = _res_list[index]
	DisplayServer.window_set_size(_res_list[index])
	Persistence.config.set_value("video", "resolution", _res_list[index])
