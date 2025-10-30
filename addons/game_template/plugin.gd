@tool
extends EditorPlugin


const AUTOLOAD_LIST := [
	"res://addons/game_template/ui_transition/SceneManager.tscn",
	"res://addons/game_template/persistence/Persistence.tscn",
	"res://addons/game_template/utils/UtilsTween.gd"
]

func _enable_plugin():
	for path in AUTOLOAD_LIST:
		add_autoload_singleton(path.get_file().get_basename(), path)

func _disable_plugin():
	for path in AUTOLOAD_LIST:
		remove_autoload_singleton(path.get_file().get_basename())
