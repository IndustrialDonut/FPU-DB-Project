extends Control




remote func _initialize_records():
	var id = multiplayer.get_rpc_sender_id()
	
	var records = Databaser.get_pay_records_for(id)
	
	rpc_id(id, "_initialize_records", records)





