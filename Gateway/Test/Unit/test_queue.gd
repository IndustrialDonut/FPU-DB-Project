extends "res://addons/gut/test.gd"

func test_the_queue():
	
	var queue = Queue.new()
	assert_eq(queue.isEmpty(), true)
	assert_eq(queue.size(), 0)
	
	queue.add_Element(321)
	assert_eq(queue.isEmpty(), false)
	assert_eq(queue.size(), 1)
	
	queue.pull_Element()
	assert_eq(queue.isEmpty(), true)
	assert_eq(queue.size(), 0)
	
	var value = queue.pull_Element()
	assert_eq(value, null)


func test_queue_incrementing():
	var queue = Queue.new()
	queue.add_Element(1)
	queue.add_Element(12)
	assert_eq(queue.size(), 2)
	
	queue.pull_Element()
	assert_eq(queue.size(), 1)
	assert_eq(queue.isEmpty(), false)
	
	queue.pull_Element()
	assert_eq(queue.size(), 0)
	
	queue.pull_Element()
	assert_eq(queue.size(), 0)


func test_queue_math():
	var queue = Queue.new()
	
	queue.add_Element(4)
	var four = queue.pull_Element()
	assert_eq(four, 4)
	
	
	queue.add_Element(5)
	queue.add_Element(10)
	
	var five = queue.pull_Element()
	var ten = queue.pull_Element()
	
	assert_eq(ten, 10)
	assert_eq(five, 5)
	

func test_bulk_the_queue():
	var queue = Queue.new()
	
	for i in range(10):
		queue.add_Element(i)
	
	for i in range(10):
		assert_eq(queue.pull_Element(), i)
		
