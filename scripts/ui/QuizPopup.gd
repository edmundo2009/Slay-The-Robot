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
	layer = 100  # Ensure popup is above everything else
	_build_ui()

func setup(data: Dictionary) -> void:
	current_question = data
	if not is_node_ready():
		await ready
	_update_display()

func _build_ui() -> void:
	background = ColorRect.new()
	background.color = Color(0, 0, 0, 0.7)
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_STOP  # Capture mouse events
	add_child(background)
	
	panel = Panel.new()
	panel.custom_minimum_size = Vector2(800, 500)
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.mouse_filter = Control.MOUSE_FILTER_STOP  # Ensure panel blocks clicks
	background.add_child(panel)
	
	var vbox = VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.add_theme_constant_override("separation", 20)
	# Add margins
	vbox.offset_left = 20
	vbox.offset_right = -20
	vbox.offset_top = 20
	vbox.offset_bottom = -20
	panel.add_child(vbox)
	
	question_label = RichTextLabel.new()
	question_label.custom_minimum_size = Vector2(0, 200)
	question_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	question_label.bbcode_enabled = true
	question_label.fit_content = true
	question_label.scroll_active = false
	question_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_child(question_label)
	
	# Answer Container (inside VBox now, not separate)
	answer_container = HBoxContainer.new()
	answer_container.alignment = BoxContainer.ALIGNMENT_CENTER
	answer_container.add_theme_constant_override("separation", 20)
	answer_container.custom_minimum_size = Vector2(0, 120)
	vbox.add_child(answer_container)
	
	feedback_label = Label.new()
	feedback_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	feedback_label.custom_minimum_size = Vector2(0, 80)
	feedback_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
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
	print("[QuizPopup] Updating Display. Question: ", q_text) # DEBUG
	print("[QuizPopup] Options Count: ", options.size()) # DEBUG
	for i in range(options.size()):
		var opt = options[i]
		print("[QuizPopup] Option ", i, ": ", opt) # DEBUG
		var btn = TextureButton.new()
		
		# Load Kenney UI pack textures
		var btn_normal = load("res://_assets/kenney_ui-pack/PNG/Blue/Default/button_rectangle_depth_flat.png")
		var btn_hover = load("res://_assets/kenney_ui-pack/PNG/Blue/Default/button_rectangle_depth_gloss.png")
		var btn_pressed = load("res://_assets/kenney_ui-pack/PNG/Blue/Default/button_rectangle_depth_gradient.png")
		
		btn.texture_normal = btn_normal
		btn.texture_hover = btn_hover
		btn.texture_pressed = btn_pressed
		btn.stretch_mode = TextureButton.STRETCH_SCALE
		btn.custom_minimum_size = Vector2(250, 100)
		btn.mouse_filter = Control.MOUSE_FILTER_STOP
		
		# Add a label overlay for the text
		var label = Label.new()
		label.text = opt.get("text", "?")
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 48)
		label.add_theme_color_override("font_color", Color.WHITE)
		label.add_theme_color_override("font_outline_color", Color.BLACK)
		label.add_theme_constant_override("outline_size", 4)
		label.set_anchors_preset(Control.PRESET_FULL_RECT)
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		btn.add_child(label)
		
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
	var color = Color.GREEN if is_correct else Color.RED
	
	# Load the appropriate icon from Kenney UI pack
	var icon_path = "res://_assets/kenney_ui-pack/PNG/Blue/Default/icon_checkmark.png" if is_correct else "res://_assets/kenney_ui-pack/PNG/Blue/Default/icon_cross.png"
	var icon_texture = load(icon_path)
	
	if icon_texture:
		# Use the stamp_rect with the icon
		stamp_rect.texture = icon_texture
		stamp_rect.modulate = color
		stamp_rect.modulate.a = 0.0
		stamp_rect.scale = Vector2(3.0, 3.0)
		
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(stamp_rect, "scale", Vector2(2.0, 2.0), 0.5)
		tween.parallel().tween_property(stamp_rect, "modulate:a", 1.0, 0.2)
	else:
		# Fallback to label if texture fails to load
		feedback_label.text = "CORRECT!" if is_correct else "WRONG!"
		feedback_label.modulate = color
		feedback_label.add_theme_font_size_override("font_size", 64)
		
		feedback_label.pivot_offset = feedback_label.size / 2
		feedback_label.scale = Vector2(0.1, 0.1)
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(feedback_label, "scale", Vector2(1.0, 1.0), 0.5)
