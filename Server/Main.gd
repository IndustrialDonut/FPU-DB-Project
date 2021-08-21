extends Control

#multiplayer.disconnect_peer(id, true)

remote func _try_login(_user : String, _pass : String):
	
	var id = multiplayer.get_rpc_sender_id()
	
	match Databaser.authenticate(_user, _pass):
		
		Enums.VER.VERIFIED:
			
			# rpc client
			rpc_id(id, "login_success", 
			"Logged in as member.")
			
			SNetworkGlobal.register_player(id, false , _user)
			
		Enums.VER.VERIFIED_WHITELISTED:
			
			# rpc client
			rpc_id(id, "login_success", 
			"Logged in as admin.")
			
			SNetworkGlobal.register_player(id, true , _user)
		
		
		
		Enums.VER.NOUSER:
			rpc_id(id, "login_fail", "No matching username found.")
		Enums.VER.UNVERIFIED:
			rpc_id(id, "login_fail", "Password incorrect.")
		_:
			rpc_id(id, "login_fail", "Something went hella wrong tell Donut.")
			assert(0)

