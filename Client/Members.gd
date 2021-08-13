extends Control



func _on_Button_Submit_Event_Report_pressed() -> void:
	$Title_Event.hide()
	$Title_Financials.hide()
	$Title_Hours.hide()
	
	$EventForm.show()


signal event_form_submit(event, leader, review, gross, hours, dept)
func _on_EventForm_event_submitted(event, leader, review, gross, hours, dept) -> void:
	emit_signal("event_form_submit", event, leader, review, gross, hours, dept)
