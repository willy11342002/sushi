extends CanvasLayer


@export_enum("Save", "Load") var mode: String
@export_file var next_scene: String
@export_file var prev_scene: String
@export var input_dialog_scene: PackedScene
@export var confirm_dialog_scene: PackedScene
@export var alert_dialog_scene: PackedScene

@export_group("MainContainer")
@export var save_slot: PackedScene
@export var save_list: Control
@export var load_button: Button
@export var save_button: Button
@export var create_button: Button
@export var delete_button: Button
@export var exit_button: Button


var _select_slot: SaveSlot
var _save_path := "user://Saves/"


func _ready() -> void:
	match mode:
		"Load":
			save_button.hide()
		"Save":
			load_button.hide()

	_load_save_list_from_disk()


func _load_save_list_from_disk() -> void:
	if not DirAccess.dir_exists_absolute(_save_path):
		DirAccess.make_dir_absolute(_save_path)

	var file_names: Array = Array(DirAccess.get_files_at(_save_path))
	file_names.sort_custom(func(a, b):
		var a_time = FileAccess.get_modified_time(_save_path + a)
		var b_time = FileAccess.get_modified_time(_save_path + b)
		return a_time > b_time
	)

	for file_name in file_names:
		var modified_time: int = FileAccess.get_modified_time(_save_path + file_name)
		var slot: SaveSlot = save_slot.instantiate()
		save_list.add_child(slot)
		slot.setup(file_name, modified_time, _save_path + file_name)
		slot.slot_select.connect(_on_slot_select)
		slot.slot_double_click.connect(func(s):
			_on_slot_select(s)
			if mode == "Load":
				_on_load_button_up()
			elif mode == "Save":
				_on_save_button_up()
		)

	_on_slot_select(null)


func _on_slot_select(slot: SaveSlot) -> void:
	if _select_slot != null:
		_select_slot.unselect()

	_select_slot = slot

	load_button.disabled = slot == null
	save_button.disabled = slot == null
	delete_button.disabled = slot == null


func _show_create_dialog() -> void:
	var dialog: InputDialog = input_dialog_scene.instantiate() as InputDialog
	add_child(dialog)
	dialog.show_dialog(_on_create_button_confirm, "New Save")

func _show_delete_dialog() -> void:
	var dialog: ConfirmDialog = confirm_dialog_scene.instantiate() as ConfirmDialog
	add_child(dialog)
	dialog.show_dialog(_on_delete_button_confirm, "DeleteConfirm")


func _on_create_button_confirm(title: String) -> void:
	var data: SaveData = SaveData.create(_save_path, title)
	ResourceSaver.save(data, data.file_name)

	var slot: SaveSlot = save_slot.instantiate()
	slot.setup(data.title, data.modified_time, data.file_name)
	save_list.add_child(slot)
	save_list.move_child(slot, 0)
	slot.slot_select.connect(_on_slot_select)


func _on_save_button_up() -> void:
	Persistence.save_data()
	var dialog: AlertDialog = alert_dialog_scene.instantiate() as AlertDialog
	add_child(dialog)
	dialog.show_dialog(func(): pass, "SaveGameSuccess")


func _on_delete_button_confirm():
	OS.move_to_trash(ProjectSettings.globalize_path(_select_slot.full_path))
	_select_slot.queue_free()
	_on_slot_select(null)


func _on_load_button_up():
	Persistence.data = ResourceLoader.load(_select_slot.full_path)
	SceneManager.change_scene(next_scene)


func _on_exit_button_up() -> void:
	SceneManager.change_scene(prev_scene)
