extends Control


func _ready() -> void:
	connect("visibility_changed", self, "_visibility_changed")


func _visibility_changed() -> void:
	rpc_id(1, "_initialize_events")


remote func _initialize_events(events) -> void:
	$Event.clear()
	#events = _sort_by_date(events)
	for event in events:
		$Event.add_item(
			event["EventName"] + " " 
			+ event["Leader"] + " " 
			+ event["Datetime"], event["ID"]
			)
	
	# make it so you don't have to click an option to refresh the view
	_on_Event_item_selected(0)


func _on_Event_item_selected(index: int) -> void:
	rpc_id(1, "_get_pending_reports_for", $Event.get_selected_id())


remote func _get_pending_reports_for(reports, TOTAL_reports):
	
	print(reports)
	
	$Status.text = str(reports.size()) + " Pending reports out of " + str(TOTAL_reports) + " Total reports."
	
	for tab in $TabContainer.get_children():
		tab.free()
	
	var i = 1
	for report in reports:
		var inst = preload("res://PendingReport.tscn").instance()
		
		$TabContainer.add_child(inst)
		
		inst.name = "Report " + str(i)
		i += 1
		
		inst.find_node("Username").text = str(report["Username"])
		inst.find_node("Score").text = str(report["ReviewScore"]) + "/10"
		inst.find_node("Department").text = str(report["Department"])
		inst.find_node("Gross").text = "$" + str(report["Gross"])
		inst.find_node("Hours").text = str(report["Hours"])
		inst.find_node("Review").text = str(report["ReviewText"])
		
		inst.report_id = report["ReportID"]
		
		print("Report id is " + str(inst.report_id))


func _on_Approve_pressed() -> void:
	var tab = $TabContainer.get_current_tab_control()
	
	var rep_id = tab.report_id
	
	if rep_id:
	
		rpc_id(1, "_approve", rep_id)
		
		# refresh view afterwards
		_on_Event_item_selected(0)


func _on_Deny_pressed() -> void:
	var tab = $TabContainer.get_current_tab_control()
		
	var rep_id = tab.report_id
	
	if rep_id:
		
		rpc_id(1, "_deny", rep_id)
		
		# refresh view afterwards
		_on_Event_item_selected(0)


# COMMIT PAYOUTS
func _on_Button_pressed() -> void:
	var event_id = $Event.get_selected_id()
	
	rpc_id(1, "_run_event_payout", event_id)

signal return_pending
func _on_Button2_pressed() -> void:
	emit_signal("return_pending")
