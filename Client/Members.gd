extends Control

signal bank_viewed


func _on_Button_Submit_Event_Report_pressed() -> void:
	$This.hide()
	$EventForm.show()


func _on_EventForm_event_submitted(event, leader, review, gross, hours, dept) -> void:
	rpc_id(1, "_try_submit_event", NetworkGlobal.logged_in_token, event, leader, review, gross, hours, dept)

remote func event_report_result(message) -> void:
	print(message)
	if message:
		pass


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




func _on_Members_bank_viewed() -> void:
	pass # Replace with function body.


remote func bank_data_result(data) -> void:
	pass
