class_name Queue

var empty = true

func isEmpty():
	return empty
	
func add_Element(element):
	empty = false

func pull_Element():
	empty = true

