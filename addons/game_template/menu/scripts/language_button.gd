class_name LanguageButton extends OptionButton


@export var languages: Dictionary = {
	"English": "en",
	"繁體中文": "zh_TW",
}


func _ready() -> void:
	for lang in languages.keys():
		add_item(lang)

	var language_code: String = Persistence.config.get_value("video", "language", "en")
	var language_index: int = languages.values().find(language_code)
	if language_index != -1:
		select(language_index)

	item_selected.connect(_on_item_selected)


func _on_item_selected(index: int) -> void:
	var lang_key: String = get_item_text(index)
	var lang_code: String = languages[lang_key]
	TranslationServer.set_locale(lang_code)
	Persistence.config.set_value("video", "language", lang_code)
