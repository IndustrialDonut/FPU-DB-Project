extends Control
#4399
func _ready() -> void:

	var net = NetworkedMultiplayerENet.new()
	net.create_server(4399, 100) # 100 max users
	multiplayer.set_network_peer(net)

	multiplayer.connect("network_peer_connected", self, "_user_connected")
	multiplayer.connect("network_peer_disconnected", self, "_user_disconnected")

func _user_connected(id) -> void:
	print("Player ID " + str(id) + " connected!")

func _user_disconnected(id) -> void:
	print("Player ID " + str(id) + " disconnected!")


# User connection tries to login, must verify with authenticator.
# Then, generate token for the user and the dbserver, pass to each.
# Pass the user off to the dbserver once tokens distributed, 
remote func _try_login(_user : String, _pass : String):
	
	var id = multiplayer.get_rpc_sender_id()
	var peer_ip = multiplayer.network_peer.get_peer_address(id)
	
	var distributed_ip
	if peer_ip != "10.0.0.8":
		distributed_ip = SNetworkGlobal.DBSERVER_IP_PUBLIC
	else:
		distributed_ip = SNetworkGlobal.DBSERVER_IP_LOCAL
	
	match Databaser.authenticate(_user, _pass):
		
		Enums.VER.VERIFIED:
			var token = _login_success(_user)
			
			# rpc client
			rpc_id(id, "login_success", 
			token,
			distributed_ip,
			SNetworkGlobal.DBSERVER_PORT,
			"Logged in as member.")
			
			# initiate rpc to db through singleton w/ custom multiplayer
			SNetworkGlobal.send_token_db(token, _user, false)
			
		Enums.VER.VERIFIED_WHITELISTED:
			var token = _login_success(_user)
			
			# rpc client
			rpc_id(id, "login_success", 
			token,
			distributed_ip,
			SNetworkGlobal.DBSERVER_PORT,
			"Logged in as admin.")
			
			# initiate rpc to db through singleton w/ custom multiplayer
			SNetworkGlobal.send_token_db(token, _user, true)
			
		Enums.VER.NOUSER:
			rpc_id(id, "login_fail", "No matching username found.")
		Enums.VER.UNVERIFIED:
			rpc_id(id, "login_fail", "Password incorrect.")
		_:
			rpc_id(id, "login_fail", "Something went hella wrong tell Donut.")
			assert(0)


func _login_success(user) -> String:
	var token = _s_generate_new_token()
	print("User " + user + " logged in!")
	return token


func _s_generate_new_token() -> String:
	randomize()
	var token = str(randi()) + str(OS.get_unix_time())
	return token
