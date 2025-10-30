extends Node


func shake(node: Node, shake_amount: float, shake_duration: float, shake_count: int = 10) -> void:
	var tween = node.create_tween()
	var original_position = node.position
	
	# Create multiple shake steps
	for i in range(shake_count):
		var progress = float(i) / shake_count
		var current_amount = shake_amount * (1.0 - progress)  # Gradually reduce shake
		var random_offset = Vector2(
			randf_range(-current_amount, current_amount),
			randf_range(-current_amount, current_amount)
		)
		tween.tween_property(node, "position", original_position + random_offset, shake_duration / shake_count)
	
	# Return to original position
	tween.tween_property(node, "position", original_position, shake_duration / shake_count)

	await tween.finished
