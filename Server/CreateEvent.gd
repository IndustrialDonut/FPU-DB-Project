extends Control


remote func _create_event(dict):
	# ID and committed should auto default in SQL
	
	var id = multiplayer.get_rpc_sender_id()
	
	if SNetworkGlobal.idIsAdmin(id):
	
		var b = Databaser.insert_event(dict)
		
		if b:
			rpc_id(id, "_message", "Event created!")
		else:
			rpc_id(id, "_message", 0)
