extends "res://addons/gut/test.gd"



func test_the_queue():
	
	var queue = Queue.new()
	
	
	assert_eq(queue.isEmpty(), true)
	queue.add_Element(321)
	assert_eq(queue.isEmpty(), false)
	
	
	
	
	
