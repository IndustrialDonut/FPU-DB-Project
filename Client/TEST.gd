extends Control


#func _on_Timer_timeout() -> void:
#
#	rpc_id(1, "send_image_network")
#
#
#func _on_Timer2_timeout() -> void:
#	rpc_id(1, "try_serialize_instance")
#
#
#remote func _network_image(imagedata) -> void:
#	var image = Image.new()
#	image.data = imagedata
#	var tex = ImageTexture.new()
#	tex.create_from_image(image)
#	$TextureRect.texture = tex
#
#
#
#remote func _network_dict(dict) -> void:
#	print("received dict")
#	var inst = dict2inst(dict)
#
#	print(inst.x)
#	print(inst.y)
#
#
