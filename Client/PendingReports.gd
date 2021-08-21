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


func _on_Event_item_selected(index: int) -> void:
	#var event_id = $Event.get_item_id(index)
	rpc_id(1, "_get_pending_reports_for", $Event.get_selected_id())


remote func _get_pending_reports_for(reports, TOTAL_reports):
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
		


func _on_Approve_pressed() -> void:
	pass
	#rpc_id(1, )


func _on_Deny_pressed() -> void:
	pass # Replace with function body.
