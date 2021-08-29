extends OptionButton

func get_hour() -> String:
	var i = get_selected_id()
	
	if i < 10:
		return "0" + str(i)
	else:
		return str(i)
