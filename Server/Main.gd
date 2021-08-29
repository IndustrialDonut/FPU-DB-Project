extends Control

#multiplayer.disconnect_peer(id, true)

remote func _try_login(_user : String, _pass : String):
	
	var id = multiplayer.get_rpc_sender_id()
	
	var eLogin = Databaser.authenticate(_user, _pass)
	
	match eLogin:
		
		Enums.VER.VERIFIED, Enums.VER.VERIFIED_WHITELISTED:
			
			var message = "Logged in."
			
			var member = Databaser.member_status(_user)
			
			var admin = false
			
			if eLogin == Enums.VER.VERIFIED_WHITELISTED:
				
				admin = true
				
				message = "Logged in as admin."
				
			# rpc client
			rpc_id(id, "login_success", message)
			
			SNetworkGlobal.register_player(id, admin, _user, member)
		
		Enums.VER.NOUSER:
			rpc_id(id, "login_fail", "No matching username found.")
		
		Enums.VER.WRONGPASS:
			rpc_id(id, "login_fail", "Password incorrect.")
		
		Enums.VER.INACTIVE:
			rpc_id(id, "login_fail", "Account is not activated.")
		
		_:
			rpc_id(id, "login_fail", "Something went hella wrong tell Donut.")
			assert(0)

