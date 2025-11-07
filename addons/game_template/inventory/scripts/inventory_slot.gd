class_name InventorySlot extends Slot


var count_string: String:
	get:
		if data.resource == null:
			return ""
		if data.count <= 1:
			return ""
		else:
			return str(data.count)

func _init() -> void:
	data = SlotResource.new()


func set_item(item: BaseItem, amount: int = 1) -> void:
	data.resource = item
	data.count = amount
	res_changed.emit()


func add_quantity(amount: int) -> int:
	if data.resource == null:
		return amount
	
	var item = data.resource as BaseItem
	var space_available = item.max_stack - data.count
	var amount_to_add = min(amount, space_available)
	data.count += amount_to_add
	res_changed.emit()
	return amount - amount_to_add  # 返回剩餘數量


func remove_quantity(amount: int) -> int:
	var amount_to_remove = min(amount, data.count)
	data.count -= amount_to_remove
	if data.count <= 0:
		clear()
	else:
		res_changed.emit()
	return amount - amount_to_remove  # 返回剩餘數量


func clear() -> void:
	data.resource = null
	data.count = 0
	res_changed.emit()


func is_empty() -> bool:
	return data.resource == null
