class_name SpecialButton
extends Button

export(String) var scene

signal special_signal(scene_name)


func _on_SpecialButton_pressed() -> void:
	emit_signal("special_signal", scene)
