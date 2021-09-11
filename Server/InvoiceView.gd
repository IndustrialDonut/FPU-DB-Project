extends Control


remote func _initialize_records():
	
	var id = multiplayer.get_rpc_sender_id()
	
	var records = Databaser.get_paid_payrecords()
	
	rpc_id(id, "_initialize_records", records)

