extends Node

var array = [55, 90, 532, 12, 653]

func _ready() -> void:
	
	var reference1 = array
	var reference2 = array
	
	reference1[2] = 0
	
	print(reference2[2])

