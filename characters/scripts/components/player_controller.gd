class_name PlayerController extends BaseComponent



var animation_tree: AnimationTree


func _ready() -> void:
	super._ready()
	animation_tree = player.get_node("AnimationTree")


func get_input() -> void:
	var direction: Vector2 = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	direction = direction.normalized() * player.move_speed
	player.get_component(CharacterModel).update_face_direction()
	player.velocity = direction
	
	if !player.velocity:
		if player.state != Character.State.IDLE:
			player.state = Character.State.IDLE
	else:
		player.last_facing_direction = direction.normalized()
		if player.state != Character.State.WALK:
			player.state = Character.State.WALK

	animation_tree.set("parameters/Idle/blend_position", player.last_facing_direction)
	animation_tree.set("parameters/Walk/blend_position", player.last_facing_direction)


func _process(_delta: float) -> void:
	get_input()
	player.move_and_slide()
