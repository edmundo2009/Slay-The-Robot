class_name QuizPopup
extends CanvasLayer

signal answer_selected(is_correct: bool)

# Nodes (dynamic)
var background: ColorRect
var panel: Panel
var question_label: RichTextLabel
var question_image: TextureRect  # NEW: For displaying traffic signs and other images
var answer_container: HBoxContainer
var feedback_label: Label
var stamp_rect: TextureRect

var current_question: Dictionary = {}
var image_path_mapping: Dictionary = {}

func _ready() -> void:
	layer = 100  # Ensure popup is above everything else
	_load_image_mapping()
	_build_ui()

func _load_image_mapping() -> void:
	var mapping_path = "res://_assets/image_path_mapping.json"
	if FileAccess.file_exists(mapping_path):
		var json_string = FileAccess.get_file_as_string(mapping_path)
		var json = JSON.new()
		var error = json.parse(json_string)
		if error == OK:
			var data = json.data
			if data.has("path_mapping"):
				image_path_mapping = data["path_mapping"]
				print("[QuizPopup] Loaded %d image path mappings" % image_path_mapping.size())
			else:
				printerr("[QuizPopup] No path_mapping found in image_path_mapping.json")
		else:
			printerr("[QuizPopup] Failed to parse image_path_mapping.json")
	else:
		printerr("[QuizPopup] image_path_mapping.json not found at: ", mapping_path)

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
	panel.custom_minimum_size = Vector2(900, 700)
	# Center the panel properly
	panel.anchor_left = 0.5
	panel.anchor_top = 0.5
	panel.anchor_right = 0.5
	panel.anchor_bottom = 0.5
	panel.offset_left = -450  # Half of width
	panel.offset_top = -350   # Half of height
	panel.offset_right = 450
	panel.offset_bottom = 350
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# Add visible panel background using StyleBoxFlat
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color(0.15, 0.15, 0.2, 0.95)  # Dark blue-grey
	panel_style.set_border_width_all(4)
	panel_style.border_color = Color(0.3, 0.5, 0.8, 1.0)  # Blue border
	panel_style.set_corner_radius_all(12)
	panel.add_theme_stylebox_override("panel", panel_style)
	
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
	question_label.custom_minimum_size = Vector2(0, 100)
	question_label.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	question_label.bbcode_enabled = true
	question_label.fit_content = true
	question_label.scroll_active = false
	question_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	question_label.add_theme_font_size_override("normal_font_size", 20)
	vbox.add_child(question_label)
	
	# Question Image (for traffic signs, etc.)
	question_image = TextureRect.new()
	question_image.custom_minimum_size = Vector2(0, 300)
	question_image.size_flags_vertical = Control.SIZE_EXPAND_FILL
	question_image.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	question_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	question_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	question_image.visible = false  # Hidden by default, shown when image exists
	vbox.add_child(question_image)
	
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
	
	# Handle question image if present
	var img_url = current_question.get("question_image_url", "")
	if img_url != null and img_url != "":
		# Try exact match first
		var img_path = image_path_mapping.get(img_url, "")
		
		# Strategy 1: If no exact match, try keys that end with the img_url
		if img_path == "":
			for key in image_path_mapping.keys():
				if key.ends_with(img_url):
					img_path = image_path_mapping[key]
					print("[QuizPopup] Found match (ends_with): %s -> %s" % [key, img_path])
					break
		
		# Strategy 2: Try to match just the filename
		if img_path == "":
			var filename = img_url.get_file()  # Gets just the filename from path
			for key in image_path_mapping.keys():
				if key.get_file() == filename:
					img_path = image_path_mapping[key]
					print("[QuizPopup] Found match (filename): %s -> %s" % [key, img_path])
					break
		
		if img_path != "":
			# Ensure it has res:// prefix
			if not img_path.begins_with("res://"):
				img_path = "res://" + img_path
			
			print("[QuizPopup] Loading image: ", img_path)
			
			if FileAccess.file_exists(img_path):
				var texture = load(img_path)
				if texture:
					question_image.texture = texture
					question_image.visible = true
					print("[QuizPopup] Successfully loaded image")
				else:
					question_image.visible = false
					printerr("[QuizPopup] Failed to load texture from: ", img_path)
			else:
				question_image.visible = false
				printerr("[QuizPopup] Mapped image file not found: ", img_path)
		else:
			question_image.visible = false
			printerr("[QuizPopup] No mapping found for image URL: ", img_url)
	else:
		question_image.visible = false
	
	# Reset
	stamp_rect.modulate.a = 0.0
	feedback_label.text = ""
	
	for c in answer_container.get_children():
		c.queue_free()
		
	var options = current_question.get("options", [])
	print("[QuizPopup] Updating Display. Question: ", q_text) # DEBUG
	print("[QuizPopup] Options Count: ", options.size()) # DEBUG
	
	# Validate we have options
	if options.size() == 0:
		printerr("[QuizPopup] ERROR: Question has no options! Closing popup.")
		queue_free()
		return
	
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
	# Load the appropriate icon from Kenney UI pack
	var icon_path = "res://_assets/kenney_ui-pack/PNG/Blue/Default/check_square_color_checkmark.png" if is_correct else "res://_assets/kenney_ui-pack/PNG/Blue/Default/check_square_color_cross.png"
	var icon_texture = load(icon_path)
	
	if icon_texture:
		# Use the stamp_rect with the icon
		stamp_rect.texture = icon_texture
		stamp_rect.modulate = Color.WHITE  # Don't tint, use original colors
		stamp_rect.modulate.a = 0.0
		stamp_rect.scale = Vector2(1.5, 1.5)
		
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(stamp_rect, "scale", Vector2(1.0, 1.0), 0.5)
		tween.parallel().tween_property(stamp_rect, "modulate:a", 1.0, 0.2)
	else:
		# Fallback to label if texture fails to load
		var color = Color.GREEN if is_correct else Color.RED
		feedback_label.text = "CORRECT!" if is_correct else "WRONG!"
		feedback_label.modulate = color
		feedback_label.add_theme_font_size_override("font_size", 64)
		
		feedback_label.pivot_offset = feedback_label.size / 2
		feedback_label.scale = Vector2(0.1, 0.1)
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(feedback_label, "scale", Vector2(1.0, 1.0), 0.5)
