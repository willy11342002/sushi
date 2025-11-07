class_name Affix extends Resource


var setting: Resource = null
var uid: String = ""
var tier: int = 0
var value: float = 0.0


func roll_value() -> void:
	var _min: float = setting.tiers[tier - 1] if tier > 0 else 0.0
	var _max: float = setting.tiers[tier]
	value = randf_range(_min, _max)

func roll_tier() -> void:
	tier = randi() % setting.tiers.size()

func upgrade(resource: Resource) -> void:
	var current_value = resource.get(setting.stat)
	if current_value == null:
		return

	var current_type = typeof(current_value)
	if current_type == TYPE_INT:
		value = int(value)
	elif current_type == TYPE_FLOAT:
		value = float(value)
	else:
		push_error("Affix can only be applied to int or float stats, got %s" % typeof(current_value))
		return

	match setting.operation:
		"Add":
			resource.set(setting.stat, current_value + value)
		"Multiply":
			resource.set(setting.stat, current_value * value)

func downgrade(resource: Resource) -> void:
	var current_value = resource.get(setting.stat)
	if current_value == null:
		return

	var current_type = typeof(current_value)
	if current_type == TYPE_INT:
		value = int(value)
	elif current_type == TYPE_FLOAT:
		value = float(value)
	else:
		push_error("Affix can only be applied to int or float stats, got %s" % typeof(current_value))
		return

	match setting.operation:
		"Add":
			resource.set(setting.stat, current_value - value)
		"Multiply":
			resource.set(setting.stat, current_value / value)

func set_setting(_setting: AffixSetting, _tier = null) -> void:
	setting = _setting

	if typeof(_tier) != TYPE_INT:
		roll_tier()
	elif _tier < 0:
		roll_tier()
	elif _tier >= setting.tiers.size():
		roll_tier()
	else:
		tier = _tier

	roll_value()
