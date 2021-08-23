class_name Queue

var size = 0
var elements = []

func isEmpty():
	if size:
		return false
	else:
		return true


func add_Element(element):
	size += 1
	elements.append(element)


func pull_Element():
	if size > 0:
		size -= 1
		
		var temp = elements[0]
		elements.remove(0)
		return temp
	
	if size == 0:
		return null


func size():
	return size
