class_name QuizPopup
extends CanvasLayer

signal answer_selected(is_correct: bool)

# Nodes (dynamic)
var background: ColorRect
var panel: Panel
var question_label: RichTextLabel
var answer_container: HBoxContainer
var feedback_label: Label
var stamp_rect: TextureRect

var current_question: Dictionary

func _ready() -> void:
	if get_child_count() == 0:
		_build_ui()

func setup(data: Dictionary) -> void:
	current_question = data
	_update_display()

func _build_ui() -> void:
	background = ColorRect.new()
	background.color = Color(0, 0, 0, 0.7)
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	
	panel = Panel.new()
	panel.custom_minimum_size = Vector2(800, 500)
	panel.set_anchors_preset(Control.PRESET_CENTER)
	background.add_child(panel)
	
	var vbox = VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	# Add margins manually if needed or just use container logic
	panel.add_child(vbox)
	
	question_label = RichTextLabel.new()
	question_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	question_label.bbcode_enabled = true
	vbox.add_child(question_label)
	
	answer_container = HBoxContainer.new()
	answer_container.size_flags_vertical = Control.SIZE_SHRINK_END
	answer_container.custom_minimum_size.y = 100
	vbox.add_child(answer_container)
	
	feedback_label = Label.new()
	feedback_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(feedback_label)
	
	# Stamp Overlay
	stamp_rect = TextureRect.new()
	stamp_rect.set_anchors_preset(Control.PRESET_CENTER)
	stamp_rect.custom_minimum_size = Vector2(256, 256)
	stamp_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stamp_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	stamp_rect.modulate.a = 0.0 # Hidden initially
	stamp_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(stamp_rect) # Add to CanvasLayer, above panel

func _update_display() -> void:
	if not current_question: return
	
	var q_text = current_question.get("question_text", "No Text")
	question_label.text = "[center]%s[/center]" % q_text
	
	# Reset
	stamp_rect.modulate.a = 0.0
	feedback_label.text = ""
	
	for c in answer_container.get_children():
		c.queue_free()
		
	var options = current_question.get("options", [])
	for i in range(options.size()):
		var opt = options[i]
		var btn = Button.new()
		btn.text = opt.get("text", "?")
		btn.custom_minimum_size = Vector2(200, 50)
		btn.pressed.connect(func(): _on_answer(i))
		answer_container.add_child(btn)

func _on_answer(idx: int) -> void:
	var correct_idx = int(current_question.get("correct_answer", -1))
	var is_correct = (idx == correct_idx)
	
	for btn in answer_container.get_children():
		btn.disabled = true
	
	_animate_result(is_correct)
	
	await get_tree().create_timer(1.5).timeout
	answer_selected.emit(is_correct)
	queue_free()

func _animate_result(is_correct: bool) -> void:
	var text = "O" if is_correct else "X"
	var color = Color.GREEN if is_correct else Color.RED
	
	# Since we don't have textures yet, generate a placeholder texture or use label
	# For now, let's use a big label overlay or just text
	# But I added stamp_rect. Let's create a PlaceholderTexture2D or load icon.svg tinted?
	# Or just use the feedback_label with big font.
	
	# Let's pivot to using a big specialized Label for the stamp since I don't have assets
	if stamp_rect.texture == null:
		# Fallback to label scale
		feedback_label.text = "CORRECT!" if is_correct else "WRONG!"
		feedback_label.modulate = color
		feedback_label.add_theme_font_size_override("font_size", 64)
		
		# Tween the label
		feedback_label.pivot_offset = feedback_label.size / 2
		feedback_label.scale = Vector2(0.1, 0.1)
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(feedback_label, "scale", Vector2(1.0, 1.0), 0.5)
	
	# If we had texture:
	# stamp_rect.texture = correct_texture if is_correct else wrong_texture
	# stamp_rect.modulate = color
	# stamp_rect.scale = Vector2(2.0, 2.0)
	# var tween = create_tween()
	# tween.tween_property(stamp_rect, "scale", Vector2(1.0, 1.0), 0.5)
	# tween.parallel().tween_property(stamp_rect, "modulate:a", 1.0, 0.2)

