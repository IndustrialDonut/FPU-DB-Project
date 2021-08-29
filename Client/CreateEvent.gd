extends Control

signal return_from_createevent(node)


func _on_Submit_pressed() -> void:
	var dict = {}
	
	dict["EventName"] = $VBoxContainer2/EventName.text
	
	dict["Leader"] = $VBoxContainer2/Leader.text
	
	dict["Datetime"] = _get_selected_datetime()
	
	rpc_id(1, "_create_event", dict)



func _get_selected_datetime() -> String:
	var string = $VBoxContainer2/Year.get_year()
	string += ":" + $VBoxContainer2/Month.get_month() + ":"
	string += $VBoxContainer2/Day.get_day() + ":"
	string += $VBoxContainer2/Hour.get_hour() + ":"
	string += $VBoxContainer2/Minute.get_minute()
	return string


func _on_Return_pressed() -> void:
	emit_signal("return_from_createevent", self)
