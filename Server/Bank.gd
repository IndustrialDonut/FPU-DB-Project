extends Control

remote func _initialize_view() -> void:
	var id = multiplayer.get_rpc_sender_id()

	var custom = Databaser.get_bank_custom_transactions()
	
	var paid_payrecords = Databaser.get_paid_payrecords()

	var bank_account_amount = _generate_bank_cumulative_total(custom, paid_payrecords)
	
	var unpaid_payrecs = Databaser.generate_payrecords_to_pay()
	
	if custom.size():
		rpc_id(id, "_initialize_view", custom, bank_account_amount)
	
	if unpaid_payrecs.size():
		rpc_id(id, "_generate_unpaid_payrecords", unpaid_payrecs)
	
	if paid_payrecords.size():
		rpc_id(id, "_generate_paid_payrecords", paid_payrecords)


	# Add all custom transactions that are TO UserTest to a running total,
	# subtract all custom transactions that are FROM UserTest from that total,
	# subtract all PayRecords from that total,
	# all other custom transactions between depts irr. in current implementation,
	# result is cumulative total.
func _generate_bank_cumulative_total(customs, paid_records):
	
	var bank_total = 0
	
	for record in customs:
		if record["Recipient"] == "UserTest":
			bank_total += record["Payment"]
		
		elif record["FromUser"]:
			if record["FromUser"] == "UserTest":
				bank_total -= record["Payment"]
	
	for record in paid_records:
		bank_total -= record["Payment"]
	
	return bank_total



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
	
