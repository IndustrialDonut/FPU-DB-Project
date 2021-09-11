extends Control

remote func _initialize_view() -> void:
	var id = multiplayer.get_rpc_sender_id()

	var custom = Databaser.get_bank_custom_transactions()
	
	var paid_payrecords = Databaser.get_paid_payrecords()

	var bank_account_amount = Databaser.generate_bank_cumulative_total()
	
	var unpaid_payrecs = Databaser.generate_payrecords_to_pay()
	
	if custom.size():
		rpc_id(id, "_initialize_view", custom, bank_account_amount)
	
	if unpaid_payrecs.size():
		rpc_id(id, "_generate_unpaid_payrecords", unpaid_payrecs)
	
	if paid_payrecords.size():
		rpc_id(id, "_generate_paid_payrecords", paid_payrecords)


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


remote func _pay_record_by_username(username):
	var id = multiplayer.get_rpc_sender_id()
	
	if SNetworkGlobal.idIsAdmin(id):
		Databaser.commit_member_payment(username)
		
		_initialize_view()
	
