extends Control

func _hide_this():
	$Title_Event.hide()
	$Title_Financials.hide()
	$Title_Hours.hide()
	$Quit.hide()

func _show_this():
	$Title_Event.show()
	$Title_Financials.show()
	$Title_Hours.show()
	$Quit.show()

func _on_Button_Submit_Event_Report_pressed() -> void:
	_hide_this()
	$EventForm.show()


signal event_form_submit(event, leader, review, gross, hours, dept)
func _on_EventForm_event_submitted(event, leader, review, gross, hours, dept) -> void:
	emit_signal("event_form_submit", event, leader, review, gross, hours, dept)


func _on_EventForm_return_from_eventform() -> void:
	_show_this()
	$EventForm.hide()


func _on_Button_pressed() -> void:
	get_tree().quit()


func _on_View_Pending_Report_pressed() -> void:
	_hide_this()
	$PendingReports.show()


func _on_View_Bank_pressed() -> void:
	_hide_this()
	$Bank.show()
