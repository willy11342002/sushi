extends Slot

@export var animation: AnimationPlayer

var count: int = 0:
	get:
		return count
	set(value):
		count = value
		res_changed.emit()
		animation.play("pop_up")

func count_string():
	if count == 0:
		return ""
	else:
		return "x%d" % count
