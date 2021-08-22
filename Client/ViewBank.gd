extends Button



signal view_bank(scene_name)
func _on_ViewBank_pressed() -> void:
	emit_signal("view_bank", "Bank")
