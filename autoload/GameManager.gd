extends Node

# === GAME MODE ===
enum GameMode {
	GAME,   # HP limits, Timer active, Enemy attacks, Stress mechanics
	STUDY   # Infinite HP, No timer, Passive enemy, No penalties
}
var current_game_mode: GameMode = GameMode.GAME

# === LANGUAGE MODE ===
enum LanguageMode {
	JP_EN,      # Both languages shown (default for learners)
	JP_ONLY,    # Japanese only (exam simulation)
	EN_ASSIST   # Japanese primary, English hints on tap
}
var current_language_mode: LanguageMode = LanguageMode.JP_EN

# === QUIZ FIELD CONFIGURATION ===
# Controls what data is displayed during quiz intercept
var quiz_config: Dictionary = {
	"show_furigana": true,          # Display reading above kanji
	"show_romaji": false,           # Display romanization
	"show_english_question": true,  # Show EN translation of question
	"show_english_answers": true,   # Show EN translation of answers
	"show_explanation": true,       # Show explanation after answer
	"explanation_language": "both", # "jp", "en", or "both"
	"enable_glossary_tap": true,    # Allow tapping terms for definitions
	"highlight_keywords": true      # Bold/color important terms
}

# === SIGNALS ===
signal game_mode_changed(new_mode: GameMode)
signal language_mode_changed(new_mode: LanguageMode)
signal quiz_config_changed(key: String, value: Variant)

func set_game_mode(mode: GameMode) -> void:
	if current_game_mode == mode:
		return
	current_game_mode = mode
	emit_signal("game_mode_changed", mode)
	print("[GameManager] Game Mode set to: ", GameMode.keys()[mode])

func set_language_mode(mode: LanguageMode) -> void:
	if current_language_mode == mode:
		return
	current_language_mode = mode
	emit_signal("language_mode_changed", mode)
	print("[GameManager] Language Mode set to: ", LanguageMode.keys()[mode])

func toggle_quiz_setting(key: String) -> void:
	if quiz_config.has(key):
		quiz_config[key] = !quiz_config[key]
		emit_signal("quiz_config_changed", key, quiz_config[key])
		print("[GameManager] Quiz Setting '%s' toggled to: %s" % [key, quiz_config[key]])
	else:
		push_warning("[GameManager] Attempted to toggle invalid quiz setting: " + key)

func set_quiz_setting(key: String, value: Variant) -> void:
	if quiz_config.has(key):
		quiz_config[key] = value
		emit_signal("quiz_config_changed", key, value)
		print("[GameManager] Quiz Setting '%s' set to: %s" % [key, value])
	else:
		push_warning("[GameManager] Attempted to set invalid quiz setting: " + key)
