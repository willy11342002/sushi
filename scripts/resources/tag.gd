class_name Tag extends Resource


func on_upgrade(offering: Offering) -> void:
	if not offering.tags.has(self):
		offering.tags[self] = 0
	offering.tags[self] += 1


func on_downgrade(offering: Offering) -> void:
	if offering.tags.has(self):
		offering.tags[self] -= 1
		if offering.tags[self] <= 0:
			offering.tags.erase(self)
