class_name AudioSlider extends HSlider


@export var bus_name: String = "Master"


func _ready() -> void:
	value = db_to_linear(Persistence.config.get_value("audio", bus_name, 1.0))
	value_changed.connect(_on_value_changed)


func _on_value_changed(_value: float) -> void:
	_value = linear_to_db(_value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), _value)
	Persistence.config.set_value("audio", bus_name, _value)
