extends Node

var last_validation_token = null
var waiting_admin_status = false
var waiting_username = null

var connected_dictionary = {1 : {"user" : "SERVER", "admin" : false}}

func idToUsername(id) -> String:
	return connected_dictionary[id]["user"]

func idIsAdmin(id) -> bool:
	return connected_dictionary[id]["admin"]


func _ready() -> void:
	var net = NetworkedMultiplayerENet.new()
	net.create_server(3005)
	get_tree().set_network_peer(net)
	
	get_tree().connect("network_peer_connected", self, "_user_connected")
	get_tree().connect("network_peer_disconnected", self, "_user_disconnected")

func _user_connected(id) -> void:
	
	print("Player ID " + str(id) + " connected!")
	
	rpc_id(id, "_check_token")

func _user_disconnected(id) -> void:
	
	connected_dictionary.erase(id)
	
	print("Player ID " + str(id) + " disconnected!")


remote func _prepare_client_connection(token, user, admin) -> void:
	last_validation_token = token
	waiting_admin_status = admin
	waiting_username = user
	$TokenTimer.start()


remote func _check_token(token):
	var id = multiplayer.get_rpc_sender_id()
	
	if token != last_validation_token:
		multiplayer.disconnect_peer(id, true)
	else:
		connected_dictionary[id]["user"] = waiting_username
		connected_dictionary[id]["admin"] = waiting_admin_status
		_reset_temporaries()


# called by timer and once a player is validated and joined on here
func _reset_temporaries() -> void:
	last_validation_token = null
	waiting_admin_status = false
	waiting_username = null
