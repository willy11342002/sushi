extends CanvasLayer


@export var animation: AnimationPlayer
@export var rect: ColorRect
@export var shader_effects: Dictionary[String, ShaderMaterial]


func _ready() -> void:
	rect.hide()


func change_scene(new_scene_path: String, effect_name = null) -> void:
	var shader: ShaderMaterial
	if effect_name and shader_effects.has(effect_name):
		shader = shader_effects[effect_name]
	else:
		var index = randi_range(0, shader_effects.size() - 1)
		shader = shader_effects[shader_effects.keys()[index]]

	rect.material = shader
	rect.show()
	animation.play("transition_out")
	await animation.animation_finished

	get_tree().change_scene_to_file(new_scene_path)

	animation.play("transition_in")
	await animation.animation_finished
	rect.hide()
