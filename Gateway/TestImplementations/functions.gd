extends Node


func sort_by_date(event_array) -> Array:
	
	var events = event_array.duplicate()
	
	var ordered_dates = _order_dates(events)
	
	var ordered_events = []
	
	for date in ordered_dates:
		
		for event in events:
			
			if event["Datetime"] == date:
				
				ordered_events.append(event.duplicate())
				
				events.erase(event)
	
	return ordered_events


func _split_date_components(datetime : String) -> PoolIntArray:
	
	var substrings : PoolStringArray = datetime.split(":", false)
	
	var num_array = []
	
	for string in substrings:
		num_array.append(int(string))
	
	return num_array


func _order_dates(events) -> Array:
	
	#var all_datestrings = []
	
	var all_components = []
	
	for event in events:
		#all_datestrings.append(event["Datetime"])
		
		var comps = _split_date_components(event["Datetime"])
		all_components.append(comps)
	
	var ordered_years = []
	var ordered_months = []
	var ordered_days = []
	var ordered_hours = []
	var ordered_mins = []

	for event_comps in all_components:
		ordered_years.append(event_comps[0])
		ordered_months.append(event_comps[1])
		ordered_days.append(event_comps[2])
		ordered_hours.append(event_comps[3])
		ordered_mins.append(event_comps[4])
	
	ordered_years = _sort_numerical_array(ordered_years)
	ordered_months = _sort_numerical_array(ordered_months)
	ordered_days = _sort_numerical_array(ordered_days)
	ordered_hours = _sort_numerical_array(ordered_hours)
	ordered_mins = _sort_numerical_array(ordered_mins)
	
	ordered_years.invert()
	ordered_months.invert()
	ordered_days.invert()
	ordered_hours.invert()
	ordered_mins.invert()
	
	var temp = []
	for mins in ordered_mins:
		for array in all_components:
			if array[4] == mins:
				temp.append(array)
				all_components.erase(array)

	
	var temp2 = []
	for hour in ordered_hours:
		for array in temp:
			if array[3] == hour:
				temp2.append(array)
				temp.erase(array)
	
	var temp3 = []
	for day in ordered_days:
		for array in temp2:
			if array[2] == day:
				temp3.append(array)
				temp2.erase(array)
	
	var temp4 = []
	for month in ordered_months:
		for array in temp3:
			if array[1] == month:
				temp4.append(array)
				temp3.erase(array)
	
	var temp5 = []
	for year in ordered_years:
		for array in temp4:
			if array[0] == year:
				temp5.append(array)
				temp4.erase(array)
	
	var date_strings = []
	
	for datearray in temp5:
		var string = ""
		
		for comp in datearray:
			if comp > 9:
				string += str(comp) + ":"
			else:
				string += "0" + str(comp) + ":"
			
		var size = string.length()
		string.erase(size - 1, 1)
		
		date_strings.append(string)
	
#	for i in range(ordered_years.size()):
#		var string = ""
#		string += str(ordered_years[i])
#		string += ":"
#		if ordered_months[i] > 9:
#			string += str(ordered_months[i])
#		else:
#			string += "0" + str(ordered_months[i])
#		string += ":"
#		if ordered_days[i] > 9:
#			string += str(ordered_days[i])
#		else:
#			string += "0" + str(ordered_days[i])
#		string += ":"
#		if ordered_hours[i] > 9:
#			string += str(ordered_hours[i])
#		else:
#			string += "0" + str(ordered_hours[i])
#		string += ":"
#		if ordered_mins[i] > 9:
#			string += str(ordered_mins[i])
#		else:
#			string += "0" + str(ordered_mins[i])
#
#		date_strings.append(string)
	
	return date_strings


func _sort_numerical_array(array : Array) -> PoolIntArray:
	
	var sorted_array : PoolIntArray = []
	
	while array.size() > 0:
		
		var smallest_value = array[0] # initialize at whatever element in the array
		
		for value in array:
			if value < smallest_value:
				smallest_value = value
			
		sorted_array.append(int(smallest_value))
		array.erase(smallest_value)
	
	return sorted_array
