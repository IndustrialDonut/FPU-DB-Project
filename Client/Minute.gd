extends OptionButton

func get_minute() -> String:
	var i = get_selected_id()
	
	if i == 0:
		return "00"
	else:
		return str(i * 15)
