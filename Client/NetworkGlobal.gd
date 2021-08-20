extends Control

const SERVER_IP_DONUT = "24.6.196.226"
const SERVER_IP_LOCAL = "10.0.0.8"

const GATEWAY_SERVER_IP = SERVER_IP_LOCAL
const GATEWAY_SERVER_PORT = 4399


var bConnected = false


func _ready() -> void:
	$ConnectionStatus.modulate = Color.red
	
	multiplayer.connect("connected_to_server", self, "_connected")
	multiplayer.connect("server_disconnected", self, "_disconnected")
	
	var _net = NetworkedMultiplayerENet.new()
	
	_net.create_client(GATEWAY_SERVER_IP, GATEWAY_SERVER_PORT)
	
	multiplayer.set_network_peer(_net)

func _connected():
	bConnected = true
	$ConnectionStatus.modulate = Color.green
	
func _disconnected():
	bConnected = false
	$ConnectionStatus.modulate = Color.red

var temp_token
func try_connect_main(token, ip, port): # try to connect to the main, now that gateway has authorized
	temp_token = token
	var _net = NetworkedMultiplayerENet.new()
	_net.create_client(ip, port)
	multiplayer.network_peer = _net


remote func _check_token():
	rpc_id(1, "_check_token" , temp_token)
