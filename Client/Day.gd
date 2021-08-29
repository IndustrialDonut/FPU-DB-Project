extends OptionButton

func get_day() -> String:
	var i = get_selected_id()
	
	if i < 10:
		return "0" + str(i)
	else:
		return str(i)
