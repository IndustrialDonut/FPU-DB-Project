extends Control

# this is event REPORT, not actual event as will be done soonTM
remote func _try_submit_event(event_name, event_leader, review, gross_funds, hours, dept):
	var id = multiplayer.get_rpc_sender_id()
	
	# do not need be admin to submit report
	var user = SNetworkGlobal.user_token_dictionary[id]["user"]
	# submit
	if Databaser.submit_event_report(user, event_name, event_leader, review, gross_funds, hours, dept):
		# reported successfuly
		rpc_id(get_tree().get_rpc_sender_id(), "event_report_result", "Submit success.")
	else:
		rpc_id(get_tree().get_rpc_sender_id(), "event_report_result", 0)
