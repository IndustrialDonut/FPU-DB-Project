extends Control

remote func _try_submit_event(token, event_name, event_leader, review, gross_funds, hours, dept):
	var status = owner.verify_status(get_tree().get_rpc_sender_id(), token)
	var user = owner.user_token_dictionary[get_tree().get_rpc_sender_id()]["user"]
	if status == Enums.Verify.UNVERIFIED:
		# did not submit
		rpc_id(get_tree().get_rpc_sender_id(), "event_report_result", 0)
	else:
		# submit
		if Databaser.submit_event_report(user, event_name, event_leader, review, gross_funds, hours, dept):
			# reported successfuly
			rpc_id(get_tree().get_rpc_sender_id(), "event_report_result", "Submit success.")
		else:
			rpc_id(get_tree().get_rpc_sender_id(), "event_report_result", 0)
