class_name AttributeTracker extends Node

@export_group("Resource")
@export var resource_node: Node
@export var resource_attribute: String = "name"

@export_group("Formatting")
@export var format_node: Node
@export var format_func_name: String = ""

@export_group("Target")
@export var target_node: Node
@export var target_attribute: String = "text"

func bind_resource_node(_resource_node: Node, _resource_attribute: String = "name", _target_node: Node = null, _target_attribute: String = "text") -> void:
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


func _on_res_changed(res) -> void:
	var attribute = res.get(resource_attribute)
	if format_node != null and format_func_name != "":
		var format_func = format_node.get(format_func_name)
		attribute = format_func.call(attribute)
	target_node.set(target_attribute, attribute)
