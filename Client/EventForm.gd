extends Control

func _on_Button_pressed() -> void:
	for child in get_children():
		if child is LineEdit:
			if not child.text.length() > 0:
				print("not all fields filled out")
				return
	
	#emit_signal("event_submitted", $eventname.text, $leadername.text, $review.text, $gross.text, $hours.text.to_int(), $dept.text)
	rpc_id(1, "_try_submit_event", NetworkGlobal.logged_in_token, 
		$eventname.text, 
		$leadername.text, 
		$review.text, 
		$gross.text, 
		$hours.text.to_int(), 
		$dept.text
		)
	
	
	$eventname.text = ""
	$leadername.text = ""
	$review.text = ""
	$gross.text = ""
	$hours.text = ""
	$dept.text = ""


remote func event_report_result(message) -> void:
	print(message)
	if message:
		pass

signal return_from_eventform
func _on_returnbutton_pressed() -> void:
	emit_signal("return_from_eventform")
