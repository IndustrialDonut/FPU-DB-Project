extends Node

var user_token_dictionary = {1 : {"user" : "SERVER" , "token" : null}}

func _ready() -> void:
	var net = NetworkedMultiplayerENet.new()
	net.create_server(4399, 100) # 100 max users
	get_tree().set_network_peer(net)
	
	get_tree().connect("network_peer_connected", self, "_user_connected")
	get_tree().connect("network_peer_disconnected", self, "_user_disconnected")

func _user_connected(id) -> void:
	user_token_dictionary[id] = null
	print("Player ID " + str(id) + " connected!")

func _user_disconnected(id) -> void:
	user_token_dictionary.erase(id)
	print("Player ID " + str(id) + " disconnected!")


func verify_status(id, token, minimum_status) -> bool:
	if user_token_dictionary.has(id):
		if user_token_dictionary[id]["token"] == token:
			if minimum_status == Enums.Verify.VERIFIED_WHITELISTED:
				if Databaser.admin_check(user_token_dictionary[id]["user"]) == Enums.Verify.VERIFIED_WHITELISTED:
					return true
				else:
					return false
			else:
				return true
		else:
			return false
	else:
		return false


func login_success(id, user) -> String:
	var token = _s_generate_new_token()
	user_token_dictionary[id] = {"user" : user , "token" : token}
	print("User " + user + " logged in!")
	return token


func _s_generate_new_token() -> String:
	randomize()
	var token = str(randi()) + str(OS.get_unix_time())
	return token
