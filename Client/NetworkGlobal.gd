extends Control

var logged_in_token = null

var connected = false

var net = NetworkedMultiplayerENet.new()
func _ready() -> void:
	$ConnectionStatus.modulate = Color.red
	
	get_tree().connect("connected_to_server", self, "_connected")
	get_tree().connect("server_disconnected", self, "_disconnected")
	
	var _error = net.create_client("10.0.0.8", 4399)
	
	get_tree().set_network_peer(net)

func _connected():
	connected = true
	$ConnectionStatus.modulate = Color.green
	
func _disconnected():
	connected = false
	$ConnectionStatus.modulate = Color.red
	get_tree().network_peer = null
	net = NetworkedMultiplayerENet.new()
	net.create_client("10.0.0.8", 4399)
	get_tree().network_peer = net
