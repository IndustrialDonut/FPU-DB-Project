extends Node

# The TREE names are very important for rpc calls.

const DBSERVER_PORT = 2302
const DBSERVER_IP_LOCAL = "10.0.0.8"
const DBSERVER_IP_PUBLIC = "24.6.196.226"


func send_token_db(token, user, bAdmin):
	rpc_id(1, "_prepare_client_connection", token, user, bAdmin)
	print(token, user, bAdmin)


func _ready() -> void:
	
	custom_multiplayer = MultiplayerAPI.new()
	
	get_child(0).custom_multiplayer = custom_multiplayer
	
	custom_multiplayer.set_root_node(get_tree().root)
	
	var peer = NetworkedMultiplayerENet.new()
	
	peer.create_client(DBSERVER_IP_LOCAL, DBSERVER_PORT)
	
	multiplayer.set_network_peer(peer)
	
	multiplayer.connect("connected_to_server", self, "_db_connected")
	multiplayer.connect("server_disconnected", self, "_db_disconnected")
	multiplayer.connect("connection_failed", self, "failed")


func _process(delta):
	if not custom_multiplayer.has_network_peer():
		return # No network peer, nothing to poll
	# Poll the MultiplayerAPI so it fetches packets, emit signals, process RPCs
	custom_multiplayer.poll()


func failed():
	print("FAILED connecting!")

func _db_connected() -> void:

	print("SERVER connected!")
	
	$GatewayConnector.rpc_id(1, "test")

func _db_disconnected() -> void:

	print("SERVER disconnected!")

