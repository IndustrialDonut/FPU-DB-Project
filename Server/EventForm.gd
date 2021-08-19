extends Control

remote func _try_submit_event(token, event_name, event_leader, review, gross_funds, hours, dept):
	var id = get_tree().get_rpc_sender_id()
	if SNetworkGlobal.verify_status(id, token, Enums.Verify.VERIFIED):
		var user = SNetworkGlobal.user_token_dictionary[id]["user"]
		# submit
		if Databaser.submit_event_report(user, event_name, event_leader, review, gross_funds, hours, dept):
			# reported successfuly
			rpc_id(get_tree().get_rpc_sender_id(), "event_report_result", "Submit success.")
		else:
			rpc_id(get_tree().get_rpc_sender_id(), "event_report_result", 0)
	else:
		# did not submit
		rpc_id(get_tree().get_rpc_sender_id(), "event_report_result", 0)
		
