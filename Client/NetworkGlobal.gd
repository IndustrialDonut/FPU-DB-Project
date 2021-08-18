extends Control


var logged_in_token = null

var bConnected = false

var _net = NetworkedMultiplayerENet.new()


func _ready() -> void:
	$ConnectionStatus.modulate = Color.red
	
	get_tree().connect("connected_to_server", self, "_connected")
	get_tree().connect("server_disconnected", self, "_disconnected")
	
	var _error = _net.create_client("10.0.0.8", 4399)
	
	get_tree().set_network_peer(_net)

func _connected():
	bConnected = true
	$ConnectionStatus.modulate = Color.green
	
func _disconnected():
	bConnected = false
	$ConnectionStatus.modulate = Color.red
	get_tree().network_peer = null
	_net = NetworkedMultiplayerENet.new()
	_net.create_client("10.0.0.8", 4399)
	get_tree().network_peer = _net
