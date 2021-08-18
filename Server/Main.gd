extends Control


remote func _try_login(id : int, _user : String, _pass : String):
	match Databaser.authenticate(_user, _pass):
		Enums.Login.LOGIN_OK:
			rpc_id(id, "login_success", SNetworkGlobal.login_success(id, _user))
		Enums.Login.NO_USERNAME_FOUND:
			rpc_id(id, "login_fail", "No matching username found.")
		Enums.Login.PASSWORD_INCORRECT:
			rpc_id(id, "login_fail", "Password incorrect.")
		_:
			rpc_id(id, "login_fail", "Something went hella wrong on our end, tell Donut.")
			assert(0)

