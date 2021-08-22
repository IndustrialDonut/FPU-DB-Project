extends Control

signal bank_viewed


func _on_Button_Submit_Event_Report_pressed() -> void:
	$This.hide()
	$EventForm.show()
func _on_EventForm_return_from_eventform() -> void:
	$This.show()
	$EventForm.hide()


func _on_Button_pressed() -> void:
	get_tree().quit()


func _on_View_Pending_Report_pressed() -> void:
	$This.hide()
	$PendingReports.show()


func _on_View_Bank_pressed() -> void:
	$This.hide()
	$Bank.show()
	emit_signal("bank_viewed")


func _on_Bank__return_bank() -> void:
	$This.show()
	$Bank.hide()


func _on_PendingReports_return_pending() -> void:
	$This.show()
	$PendingReports.hide()


func _on_ViewInvoice() -> void:
	$This.hide()
	$InvoiceView.show()

func _on_CreateEvent_pressed() -> void:
	$This.hide()
	$CreateEvent.show()


func _on_InvoiceView_return_from_invoice() -> void:
	$This.show()
	$InvoiceView.hide()
