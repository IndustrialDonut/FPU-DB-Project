extends Node2D




func _ready() -> void:
	
	var child = Child.new() as Parent
	var child2 = Child2.new() as Parent
	var child3 = Child3.new() as Parent

	child.ligon()
	child2.ligon()
	child3.ligon()
	
#	var parent = Parent.new()
#
#	parent.ligon()
