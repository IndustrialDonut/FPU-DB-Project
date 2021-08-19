extends Node

# Use this var scene tree for the gateway-dbserver connection, and the
# native scene tree for the gateway-client connections.
var scene_tree_server = SceneTree.new()


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
