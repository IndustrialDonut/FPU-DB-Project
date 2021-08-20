extends Control

# this is event REPORT, not actual event as will be done soonTM
remote func _try_submit_event(dict):
	var id = multiplayer.get_rpc_sender_id()
	
	# Do not need be admin to simply submit a report.
	
	# Only Username gets filled in here, Approved defaults to 0 and owed to player
	# will get calculated when the event gets calculated, and possibly go into the bank
	# instead of here anyway.
	var user = SNetworkGlobal.idToUsername(id)
	dict["Username"] = user
	
	# submit
	if Databaser.submit_event_report(dict):
		# reported successfuly
		rpc_id(id, "event_report_result", "Submit success.")
	else:
		# failed for some reason
		rpc_id(id, "event_report_result", 0)


remote func _initialize_events():
	var id = multiplayer.get_rpc_sender_id()
	
	var array_of_records = Databaser.get_event_labels()
	
	rpc_id(id, "_initialize_events", array_of_records)
