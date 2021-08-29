extends Node


var connected_dictionary = {1 : {"user" : "SERVER", "admin" : false, "member" : "Prospect"}}


func idToUsername(id) -> String:
	return connected_dictionary[id]["user"]


func idIsAdmin(id) -> bool:
	return connected_dictionary[id]["admin"]


func idMemberStatus(id) -> String:
	return connected_dictionary[id]["member"]


func _ready() -> void:
	var net = NetworkedMultiplayerENet.new()
	net.create_server(4399)
	get_tree().set_network_peer(net)
	
	get_tree().connect("network_peer_connected", self, "_user_connected")
	get_tree().connect("network_peer_disconnected", self, "_user_disconnected")


func _user_connected(id) -> void:

	print("Player ID " + str(id) + " connected!")


func _user_disconnected(id) -> void:
	
	connected_dictionary.erase(id)
	
	print("Player ID " + str(id) + " disconnected!")


func register_player(id, admin, user, eMember):
	
	connected_dictionary[id] = {"user" : user,
								"admin" : admin,
								"member" : eMember}

