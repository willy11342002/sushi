class_name AffixSetting extends DescriptionResource


@export_enum("Add", "Multiply") var operation: String = "Add"
@export var stat: String = ""
@export var tiers: Array[float] = []


func random() -> Affix:
	var affix = Affix.new()
	affix.set_setting(self)
	return affix
