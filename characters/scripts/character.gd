class_name Character extends CharacterBody2D


enum State { IDLE, WALK, RUN, ATTACK, HURT, DEAD }
var state: State = State.IDLE
var components: Array = []

signal res_changed

@export var data: CharacterData:
	set(value):
		data = value
		emit_signal("res_changed")


func add_component(component: BaseComponent) -> void:
	components.append(component)

func get_component(component_type: Variant) -> BaseComponent:
	for component in components:
		if is_instance_of(component, component_type):
			return component
	return null


var last_facing_direction: Vector2 = Vector2.DOWN
@export var move_speed: float = 200.0

