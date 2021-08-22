extends Button

signal view_invoice(scene_name)
func _on_ViewBank_pressed() -> void:
	emit_signal("view_bank", "InvoiceView")
