extends Control

var _batch_of_events = {}

remote func _initialize_view(token) -> void:
	var id = get_tree().get_rpc_sender_id()
	if SNetworkGlobal.verify_status(id, token) == Enums.Verify.VERIFIED_WHITELISTED:
		var first = Databaser.view_pending_reports()[0]
		var total = Databaser.view_pending_reports().size()
		rpc_id(id, "_initialize_view", first, total)

remote func _approve_to_batch(token, report_id):
	if SNetworkGlobal.verify_status(get_tree().get_rpc_sender_id(), token) == Enums.Verify.VERIFIED_WHITELISTED:
		pass # approve it to the batch temporarily, then when the admin also
		# runs the batch calculation, it will be marked Approved.
		# if admin dc's before having run the calculation, the reports in the batch
		# will simply be removed from the temporary dictionary/array and remain
		# in the pending EventReports table as not yet approved.


remote func _run_batch_calculation(token):
	if SNetworkGlobal.verify_status(get_tree().get_rpc_sender_id(), token) == Enums.Verify.VERIFIED_WHITELISTED:
		pass


remote func _reject_report(token, report_id):
	if SNetworkGlobal.verify_status(get_tree().get_rpc_sender_id(), token) == Enums.Verify.VERIFIED_WHITELISTED:
		pass
