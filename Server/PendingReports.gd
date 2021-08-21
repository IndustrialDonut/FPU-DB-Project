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
		
		print(reports.size())
		
		rpc_id(id, "_get_pending_reports_for", reports, TOTAL_report_count)


remote func _approve(reportid):
	var id = multiplayer.get_rpc_sender_id()
	if SNetworkGlobal.idIsAdmin(id):
		pass


remote func _deny(reportid):
	var id = multiplayer.get_rpc_sender_id()
	if SNetworkGlobal.idIsAdmin(id):
		
		Databaser.delete_report(id)



#remote func _approve_to_batch(token, report_id):
#	if SNetworkGlobal.verify_status(get_tree().get_rpc_sender_id(), token) == Enums.Verify.VERIFIED_WHITELISTED:
#		pass # approve it to the batch temporarily, then when the admin also
		# runs the batch calculation, it will be marked Approved.
		# if admin dc's before having run the calculation, the reports in the batch
		# will simply be removed from the temporary dictionary/array and remain
		# in the pending EventReports table as not yet approved.


#remote func _run_batch_calculation(token):
#	if SNetworkGlobal.verify_status(get_tree().get_rpc_sender_id(), token) == Enums.Verify.VERIFIED_WHITELISTED:
#		pass


#remote func _reject_report(token, report_id):
#	if SNetworkGlobal.verify_status(get_tree().get_rpc_sender_id(), token) == Enums.Verify.VERIFIED_WHITELISTED:
#		pass
