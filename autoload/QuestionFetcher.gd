extends Node

# Dictionary mapping category paths (String) to Arrays of Question Dictionaries
var questions_by_category: Dictionary = {}
var all_questions: Array = []

# Map source filename to a "prefix" if needed, or just load all into global pool
const DATA_DIR = "res://_data_normalized/"
const DATA_FILES = ["navitime.json", "scrape.json", "trips.json", "tripsfull.json"]

signal data_loaded

func _ready() -> void:
	_load_all_data()

func _load_all_data() -> void:
	print("[QuestionFetcher] Loading question data...")
	questions_by_category.clear()
	all_questions.clear()
	
	var total_count = 0
	
	for filename in DATA_FILES:
		var path = DATA_DIR + filename
		if not FileAccess.file_exists(path):
			printerr("[QuestionFetcher] File not found: " + path)
			continue
			
		var json_string = FileAccess.get_file_as_string(path)
		var json = JSON.new()
		var error = json.parse(json_string)
		
		if error == OK:
			var data = json.data
			if data is Array:
				for q in data:
					_process_question(q)
					total_count += 1
			elif data is Dictionary:
				if data.has("questions"):
					for q in data["questions"]:
						_process_question(q)
						total_count += 1
				elif data.has("cards"):
					for q in data["cards"]:
						_process_question(q)
						total_count += 1
		else:
			printerr("[QuestionFetcher] JSON Parse Error in %s: line %s: %s" % [filename, json.get_error_line(), json.get_error_message()])
			
	print("[QuestionFetcher] Loaded %d questions." % total_count)
	data_loaded.emit()

func _process_question(q: Dictionary) -> void:
	# Add to main pool
	all_questions.append(q)
	
	# Index by category path
	# category_path is Array[String], e.g. ["Navitime", "Signs"]
	# We will join them with "/" for simple string lookup
	var cat_path_array = q.get("category_path", [])
	if cat_path_array is Array:
		var cat_key = "/".join(cat_path_array)
		if not questions_by_category.has(cat_key):
			questions_by_category[cat_key] = []
		questions_by_category[cat_key].append(q)
		
		# Also index by partial paths? e.g. "Navitime"
		# For now, exact match or recursive search logic might be needed later.
		# Let's index strictly by full path for now, maybe add logic to fetch by partial.

func get_random_question(category_path: String = "") -> Dictionary:
	if category_path == "" or category_path == "ANY":
		if all_questions.is_empty(): return {}
		return all_questions.pick_random()
	
	# Try exact match first
	if questions_by_category.has(category_path):
		var list = questions_by_category[category_path]
		if not list.is_empty():
			return list.pick_random()
	
	# Fallback: Check if any category STARTS with the requested path (for broad categories like "Navitime")
	# This is slower but useful
	var candidate_lists = []
	for key in questions_by_category.keys():
		if key.begins_with(category_path):
			candidate_lists.append(questions_by_category[key])
			
	if not candidate_lists.is_empty():
		var chosen_list = candidate_lists.pick_random()
		return chosen_list.pick_random()
		
	printerr("[QuestionFetcher] No questions found for category: " + category_path)
	# Ultimate fallback: return random question from ALL to prevent softlock
	if not all_questions.is_empty():
		return all_questions.pick_random()
		
	return {}
