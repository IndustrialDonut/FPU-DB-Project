extends Control


remote func _initialize_view(token) -> void:
	var id = get_tree().get_rpc_sender_id()
	if SNetworkGlobal.verify_status(id, token, Enums.Verify.VERIFIED):
		var array = Databaser.view_bank_reports()
		rpc_id(id, "_initialize_view", array, _s_total_gross_on_reports(array))
		
		# WHAT THE FUCK
		# debugger gave no error as to calling RPC on my client side when setting text = dict
		# was not ok. It just didn't do shit. WOW.
		# Literally casting dict as string fixed all this.
		
		#for record in array:
			#rpc_id(id, "_initialize_view", record, _s_total_gross_on_reports(array))
			#print(record)
			#print(_s_total_gross_on_reports(array))
			#$TextEdit.text = str(record)


func _s_total_gross_on_reports(array) -> float:
	# could use a SQL aggregate instead of this but idk if that would be simpler or more complicated
	var total = 0
	for report in array:
		total += report["Gross"]
	
	return total
