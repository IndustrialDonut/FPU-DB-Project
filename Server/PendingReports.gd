extends Control


remote func _initialize_events():
	var id = multiplayer.get_rpc_sender_id()
	if SNetworkGlobal.idIsAdmin(id):
	
		var array_of_records = Databaser.get_event_labels()
		
		rpc_id(id, "_initialize_events", array_of_records)


remote func _get_pending_reports_for(event_id):
	var id = multiplayer.get_rpc_sender_id()
	if SNetworkGlobal.idIsAdmin(id):
		var reports = Databaser.pending_reports_for(event_id) # fill this with the pending reports for the given event id
		
		var TOTAL_report_count = Databaser.total_reports_for(event_id)
		
		rpc_id(id, "_get_pending_reports_for", reports, TOTAL_report_count)


remote func _approve(REPORT_ID):
	var id = multiplayer.get_rpc_sender_id()
	if SNetworkGlobal.idIsAdmin(id):
		
		Databaser.approve_report(REPORT_ID)


remote func _deny(REPORT_ID):
	var id = multiplayer.get_rpc_sender_id()
	if SNetworkGlobal.idIsAdmin(id):
		
		Databaser.delete_report(REPORT_ID)


remote func _run_event_commit(EVENT_ID):
	Databaser.commit_event(EVENT_ID)
