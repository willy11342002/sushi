class_name CharacterModel extends BaseComponent


enum FaceDirection {
	UP,
	DOWN,
	LEFT,
	RIGHT
}
@export var face_direction: FaceDirection:
	set(value):
		face_direction = value
		match value:
			FaceDirection.UP:
				set("sprite_frames", player.data.up_frames)
			FaceDirection.DOWN:
				set("sprite_frames", player.data.down_frames)
			FaceDirection.LEFT:
				set("sprite_frames", player.data.side_frames)
				set("flip_h", true)
			FaceDirection.RIGHT:
				set("sprite_frames", player.data.side_frames)
				set("flip_h", false)


func get_facing_direction() -> CharacterModel.FaceDirection:
	if abs(player.last_facing_direction.x) > abs(player.last_facing_direction.y):
		if player.last_facing_direction.x > 0:
			return CharacterModel.FaceDirection.RIGHT
		return CharacterModel.FaceDirection.LEFT
	if player.last_facing_direction.y > 0:
		return CharacterModel.FaceDirection.DOWN
	return CharacterModel.FaceDirection.UP


func update_face_direction() -> void:
	face_direction = get_facing_direction()
