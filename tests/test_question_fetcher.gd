extends Node

func _ready() -> void:
	# Give time for autoloads to initialize if needed, though they should be ready
	await get_tree().process_frame
	
	print("Verifying QuestionFetcher data loading...")
	
	var count = QuestionFetcher.all_questions.size()
	print("Total Questions: ", count)
	
	if count == 0:
		printerr("FAILURE: No questions loaded.")
		get_tree().quit(1)
		return
		
	# Test fetching by category
	var cat = "Navitime" # Assuming this category exists in navitime.json
	var q = QuestionFetcher.get_random_question(cat)
	
	if q.is_empty():
		printerr("FAILURE: Could not fetch question for category: ", cat)
		get_tree().quit(1)
		return
		
	print("Successfully fetched question: ", q.get("id", "UNKNOWN"))
	print("SUCCESS")
	get_tree().quit(0)
