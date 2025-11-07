class_name Inventory extends Control


@export var slots_count: int = 20

@export var slot_container: Container
@export var slot_scene: PackedScene

func _ready() -> void:
	Persistence.load_data()


func dumps(data: SaveData) -> void:
	for slot in slot_container.get_children():
		data.inventories.append(slot.data)
	return

func loads(data: SaveData) -> void:
	for i in slots_count:
		var slot = slot_scene.instantiate()
		slot_container.add_child(slot)
		if i < data.inventories.size():
			slot.setup(data.inventories[i])
		slot.res_changed.emit()


func add_item(item: BaseItem, quantity: int = 1) -> bool:
	var remaining = quantity
	
	# 先嘗試堆疊到現有物品
	if item.stackable:
		for slot in slot_container.get_children():
			if slot.is_empty():
				continue
			if slot.data.resource.id == item.id:
				remaining = slot.data.add_quantity(remaining)
				if remaining <= 0:
					return true

	# 如果無法堆疊，則尋找空槽位
	for slot in slot_container.get_children():
		if slot.is_empty():
			var amount_to_add = min(remaining, item.max_stack if item.stackable else 1)
			slot.set_item(item, amount_to_add)

			remaining -= amount_to_add
			if remaining <= 0:
				return true

	return false


func remove_item(item: BaseItem, quantity: int = 1) -> bool:
	var remaining = quantity

	for slot in slot_container.get_children():
		if slot.is_empty():
			continue
		if slot.data.resource.id == item.id:
			var removed = slot.data.remove_quantity(remaining)
			remaining -= removed

			if remaining <= 0:
				return true
	return false


func get_item_count(item: BaseItem) -> int:
	var count = 0
	for slot in slot_container.get_children():
		if slot.is_empty():
			continue
		if slot.data.resource.id == item.id:
			count += slot.data.count
	return count


func swap_slots(index_a: int, index_b: int) -> void:
	var slots = slot_container.get_children()
	if index_a < 0 or index_a >= slots.size():
		return
	if index_b < 0 or index_b >= slots.size():
		return

	var index_min = min(index_a, index_b)
	var index_max = max(index_a, index_b)

	var slot_max = slot_container.get_child(index_max)
	slot_container.move_child(slot_max, index_min)
