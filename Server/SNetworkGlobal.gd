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

func _user_disconnected(id) -> void:
	user_token_dictionary.erase(id)


func verify_status(id, token) -> int:
	if user_token_dictionary.has(id):
		if user_token_dictionary[id]["token"] == token:
			return Databaser.admin_check(user_token_dictionary[id]["user"])
		else:
			return Enums.Verify.UNVERIFIED
	else:
		return Enums.Verify.UNVERIFIED


func login_success(id, user) -> String:
	var token = _s_generate_new_token()
	user_token_dictionary[id] = {"user" : user , "token" : token}
	return token


func _s_generate_new_token() -> String:
	randomize()
	var token = str(randi()) + str(OS.get_unix_time())
	return token
