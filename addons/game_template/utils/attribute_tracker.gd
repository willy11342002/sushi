class_name AttributeTracker extends Node

@export var empty_text: String = ""

@export_group("Resource")
@export var resource_node: Node
@export var resource_attribute: Array[String]
@export var resource_callable_args: Array = []

@export_group("Target")
@export var target_node: Node
@export var target_attribute: String = "text"

@export_group("Animation")
@export var use_animation: bool = false
@export var animation_duration: float = 0.5

var _last_value

func bind_resource_node(_resource_node: Node, _resource_attribute: Array[String] = ["name"], _target_node: Node = null, _target_attribute: String = "text") -> void:
	resource_node = _resource_node
	resource_attribute = _resource_attribute
	target_node = _target_node
	target_attribute = _target_attribute

	var _signal = resource_node.get("res_changed")
	if _signal:
		_signal.connect(_on_res_changed)


func _ready() -> void:
	if resource_node != null:
		bind_resource_node(resource_node, resource_attribute, target_node, target_attribute)
		var attribute = _get_attribute()
		if attribute == null:
			return
		target_node.set(target_attribute, attribute)
		_last_value = attribute

func _get_attribute():
	var attribute
	for i in resource_attribute.size():
		if i == 0:
			attribute = resource_node.get(resource_attribute[i])
		elif attribute == null:
			return null
		else:
			attribute = attribute.get(resource_attribute[i])
	if attribute is Callable:
		attribute = attribute.callv(resource_callable_args)
	return attribute

func _on_res_changed() -> void:
	var attribute = _get_attribute()
	if attribute == null:
		return
	if _last_value == attribute:
		return

	if use_animation:
		var tween = create_tween().set_parallel()
		tween.tween_property(target_node, target_attribute, attribute, animation_duration)
	else:
		target_node.set(target_attribute, attribute)

	_last_value = attribute
