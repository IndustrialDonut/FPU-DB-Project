extends Control

remote func _initialize_view() -> void:
	var id = multiplayer.get_rpc_sender_id()

	var array = Databaser.view_bank_custom_transactions()
	rpc_id(id, "_initialize_view", array, _s_total_gross_on_reports(array))
	
	# WHAT THE FUCK
	# debugger gave no error as to calling RPC on my client side when setting text = dict
	# was not ok. It just didn't do shit. WOW.
	# Literally casting dict as string fixed all this.


func _s_total_gross_on_reports(array) -> float:
	# could use a SQL aggregate instead of this but idk if that would be simpler or more complicated
	var total = 0
	for report in array:
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
