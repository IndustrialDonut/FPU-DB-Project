extends "res://addons/gut/test.gd"

var functions = preload("res://TestImplementations/functions.gd").new()

var mock_data = [
			{"Datetime" : "2020:05:13:00:48" , "ID" : 1},
			{"Datetime" : "2020:06:10:13:18" , "ID" : 8},
			{"Datetime" : "2021:08:19:14:48" , "ID" : 2},
			{"Datetime" : "2022:08:19:14:48" , "ID" : 3},
			{"Datetime" : "2021:08:19:14:48" , "ID" : 4},
			{"Datetime" : "2019:08:19:14:48" , "ID" : 5},
			]

var sorted_mock_data = [
	{"Datetime" : "2022:08:19:14:48" , "ID" : 3},
	{"Datetime" : "2021:08:19:14:48" , "ID" : 4},
	{"Datetime" : "2021:08:19:14:48" , "ID" : 2},
	{"Datetime" : "2020:06:10:13:18" , "ID" : 8},
	{"Datetime" : "2020:05:13:00:48" , "ID" : 1},
	{"Datetime" : "2019:08:19:14:48" , "ID" : 5},
]

var mock_numerical_array : PoolIntArray = [5, 8, 7, 21, 32.0 , -9, 27, -100]
var sorted_mock_numerical : PoolIntArray = [-100, -9, 5, 7, 8, 21, 27, 32]

var mock_datetime = "2020:05:13:00:48"
var mock_comps = [2020, 05, 13, 00, 48]


func test__split_date_components():
	var comps = functions._split_date_components(mock_datetime)
	
	for i in range(comps.size()):
		assert_eq(comps[i], mock_comps[i])
	


func test__order_dates():
	
	var ordered_array = functions._order_dates(mock_data)
	
	for i in range(ordered_array.size()):
		
		# ordered_array[i] is a date string
		assert_eq(ordered_array[i], sorted_mock_data[i]["Datetime"])
		

func test__sort_numerical_array():
	
	var sorted = functions._sort_numerical_array(mock_numerical_array)
	
	assert_eq_deep(sorted, sorted_mock_numerical)


func test_sort_by_date():
	
	var sorted_events = functions.sort_by_date(mock_data)
	
	# Here we made the order of events not care about the ID of the event, only the datetime
	for i in range(sorted_mock_data.size()):
		assert_eq(sorted_events[i]["Datetime"], sorted_mock_data[i]["Datetime"])

