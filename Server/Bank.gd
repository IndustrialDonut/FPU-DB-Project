extends Control

remote func _initialize_view() -> void:
	var id = multiplayer.get_rpc_sender_id()

	var custom = Databaser.get_bank_custom_transactions()
	
	var paid_payrecords = Databaser.generate_paid_payrecords()
	var total_org_profit_from_paid_records = Databaser.generate_bank_cumulative_total()#paid_payrecords[1]
	#paid_payrecords = paid_payrecords[0]
	
	var bank_account_amount = total_org_profit_from_paid_records + _s_total_gross_on_trans(custom)
	
	var unpaid_payrecs = Databaser.generate_payrecords_to_pay()
	
	if custom.size():
		rpc_id(id, "_initialize_view", custom, bank_account_amount)
	
	if unpaid_payrecs.size():
		rpc_id(id, "_generate_unpaid_payrecords", unpaid_payrecs)
	
	if paid_payrecords.size():
		rpc_id(id, "_generate_paid_payrecords", paid_payrecords)


# TOTAL BANK AMOUNT ALL CUSTOM TRANSACTIONS CONSIDERED
# HARD CODED "UserTest" is thE BANKER SO TO SAY OF THE ORG
func _s_total_gross_on_trans(custom) -> float:
	# could use a SQL aggregate instead of this but idk if that would be simpler or more complicated
	var total : float = 0
	for report in custom:
		
		if report["Recipient"]:
			if report["Recipient"] == "UserTest":
				total += report["Gross"]
				
		if report["FromUser"]:
			if report["FromUser"] == "UserTest":
				total -= report["Gross"]
	
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

