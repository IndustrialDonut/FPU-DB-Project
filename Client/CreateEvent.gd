extends Control

signal return_from_createevent(node)


remote func _result(message):
	if message:
		print(message)
		$VBoxContainer2/EventName.text = ""
		$VBoxContainer2/Leader.text = ""
		$VBoxContainer2/Department.select(0)
		for dropdown in $VBoxContainer2.get_children():
			if dropdown is OptionButton:
				dropdown.select(0)
	else:
		print("Failed to create event.")


func _on_Submit_pressed() -> void:
	var dict = {}
	
	if $VBoxContainer2/EventName.text != "" and $VBoxContainer2/Leader.text != "":
	
		dict["EventName"] = $VBoxContainer2/EventName.text
		
		dict["Leader"] = $VBoxContainer2/Leader.text
		
		dict["Datetime"] = _get_selected_datetime()
		
		rpc_id(1, "_create_event", dict)
	else:
		print("fill out necesarry details")


func _get_selected_datetime() -> String:
	var string = $VBoxContainer2/Year.get_year()
	string += ":" + $VBoxContainer2/Month.get_month() + ":"
	string += $VBoxContainer2/Day.get_day() + ":"
	string += $VBoxContainer2/Hour.get_hour() + ":"
	string += $VBoxContainer2/Minute.get_minute()
	return string


func _on_Return_pressed() -> void:
	emit_signal("return_from_createevent", self)

