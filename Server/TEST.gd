extends Control


var x = 5

var y = "hello string instance variable"


func _ready() -> void:
	practice_image_local()

func practice_image_local():
	var image = Image.new()
	var inst = TextureRect.new()
	var tex = ImageTexture.new()
	
	#image.load("res://eye.jpg")
	
	image.load("D:/GodotProjects/FreePeoplesUnionDB/FreePeoplesUnionDBProject/timingdiagram.png")
	
	tex.create_from_image(image)
	
	inst.texture = tex
	
	add_child(inst)
	inst.expand = true
	inst.rect_size = Vector2.ONE * 280


remote func send_image_network():
	
	var image = Image.new()
	
	image.load("res://eye.jpg")
	
	rpc("_network_image", image.data)


remote func try_serialize_instance():
	
	var dict = inst2dict(self)
	
	rpc("_network_dict", dict)
	
	print("tried to send dict")
	
