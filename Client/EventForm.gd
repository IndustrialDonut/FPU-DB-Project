extends Control

signal return_from_eventform(node)

func _on_Button_pressed() -> void:
	for child in get_children():
		if child is LineEdit:
			if not child.text.length() > 0:
				print("not all fields filled out")
				return
	
	# The extra information needed for the record will be handled server-side,
	# such as the username, any amount owed to player, and the approval status.
	var record_dict = {
		"Gross" : $VBoxContainer3/gross.text.to_int(),
		"Hours" : $VBoxContainer3/hours.text.to_int(),
		"ReviewText" : $review.text,
		"ReviewScore" : $HBoxContainer/Score.text.to_int(),
		"Department" : $VBoxContainer4/dept.text,
		"EventID" : $VBoxContainer/Event.get_selected_id() # this IS the EVENT ID PRIMARY KEY!!!
	}
	
	rpc_id(1, "_try_submit_event", record_dict)
	
	$VBoxContainer2/review.text = ""
	$VBoxContainer3/gross.text = ""
	$VBoxContainer3/hours.text = ""


remote func event_report_result(message) -> void:
	print(message)
	if message:
		emit_signal("return_from_eventform", self)


func _on_returnbutton_pressed() -> void:
	emit_signal("return_from_eventform", self)


func _ready() -> void:
	connect("visibility_changed", self, "_visibility_changed")


func _visibility_changed() -> void:
	rpc_id(1, "_initialize_events")


remote func _initialize_events(events) -> void:
	$VBoxContainer/Event.clear()
	if events:
		for event in events:
			$VBoxContainer/Event.add_item(
				event["EventName"] + " " 
				+ event["Leader"] + " " 
				+ event["Datetime"], event["ID"] # make sure to use Event.get_item_id since you only have signals to get INDICES
				)
