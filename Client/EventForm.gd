extends Control

signal return_from_eventform

func _on_Button_pressed() -> void:
	for child in get_children():
		if child is LineEdit:
			if not child.text.length() > 0:
				print("not all fields filled out")
				return
	
	# The extra information needed for the record will be handled server-side,
	# such as the username, any amount owed to player, and the approval status.
	var record_dict = {
		"Gross" : $gross.text.to_int(),
		"Hours" : $hours.text.to_int(),
		"ReviewText" : $review.text,
		"ReviewScore" : $Score.text.to_int(),
		"Department" : $dept.text,
		"EventID" : $Event.get_selected_id() # this IS the EVENT ID PRIMARY KEY!!!
	}
	
	rpc_id(1, "_try_submit_event", record_dict)
	
	$review.text = ""
	$gross.text = ""
	$hours.text = ""


remote func event_report_result(message) -> void:
	print(message)
	if message:
		emit_signal("return_from_eventform")


func _on_returnbutton_pressed() -> void:
	emit_signal("return_from_eventform")


func _ready() -> void:
	connect("visibility_changed", self, "_visibility_changed")


func _visibility_changed() -> void:
	rpc_id(1, "_initialize_events")


remote func _initialize_events(events) -> void:
	$Event.clear()
	#events = _sort_by_date(events)
	for event in events:
		$Event.add_item(
			event["EventName"] + " " 
			+ event["Leader"] + " " 
			+ event["Datetime"], event["ID"]
			)


func _sort_by_date(events):
	# Take an array of event dictionaries, sort them by datetime which is key "Datetime"
	# that has value stored as Y:M:D:H:MIN  
	pass
