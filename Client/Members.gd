extends Control


func _on_Button_pressed() -> void:
	get_tree().quit()


func return_from_scene(scene):
	scene.hide()
	$This.show()


func on_scene_button_pressed(scene_name):
	$This.hide()
	get_node(scene_name).show()


