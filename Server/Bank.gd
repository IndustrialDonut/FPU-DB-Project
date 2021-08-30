extends Control

remote func _initialize_view() -> void:
	var id = multiplayer.get_rpc_sender_id()

	var custom = Databaser.get_bank_custom_transactions()
	
	var paid_payrecords = Databaser.generate_paid_payrecords()
	
	var unpaid_payrecs = Databaser.generate_payrecords_to_pay()
	
	if custom.size():
		rpc_id(id, "_initialize_view", custom, _s_total_gross_on_reports(custom, paid_payrecords))
	
	if unpaid_payrecs.size():
		rpc_id(id, "_generate_unpaid_payrecords", unpaid_payrecs)
	
	if paid_payrecords.size():
		rpc_id(id, "_generate_paid_payrecords", paid_payrecords)


# NOT WORKING
func _s_total_gross_on_reports(custom, payrecords) -> float:
	# could use a SQL aggregate instead of this but idk if that would be simpler or more complicated
	var total = 0
	for report in custom:
		total += report["Gross"]
	
	return total


remote func _submit_custom_transaction(dict, bPersonal):
	var id = multiplayer.get_rpc_sender_id()
	
	if bPersonal:
		var from = SNetworkGlobal.idToUsername(id)
		dict["FromUser"] = from
	else:
		var from = SNetworkGlobal.idDepartmentStatus(id)
		dict["FromDept"] = from
	
	if SNetworkGlobal.idIsAdmin(id):
		
		if Databaser.submit_custom_transaction(dict):
			rpc_id(id, "_result", "Your custom transaction sent successfuly.")
		else:
			rpc_id(id, "_result", 0)
	
	_initialize_view()

