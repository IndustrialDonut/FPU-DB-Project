extends "res://addons/gut/test.gd"



func test_the_queue():
	
	var queue = Queue.new()
	assert_eq(queue.isEmpty(), true)
	assert_eq(queue.size(), 0)
	
	queue.add_Element(321)
	assert_eq(queue.isEmpty(), false)
	
	queue.pull_Element()
	assert_eq(queue.isEmpty(), true)
	
	var value = queue.pull_Element()
	assert_eq(value, null)
