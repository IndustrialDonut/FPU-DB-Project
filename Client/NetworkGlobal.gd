extends Control

const DONUT = "{84fdbe25-04e0-11eb-b175-806e6f6e6963}"

const SERVER_IP_DONUT = "24.6.196.226"
const SERVER_IP_LOCAL = "10.0.0.8"

var GATEWAY_SERVER_IP = SERVER_IP_LOCAL
const GATEWAY_SERVER_PORT = 4399


var bConnected = false


func _ready() -> void:
	
	#var test = "132456789.555001"
	#print(StringHelper.numberStringCommas(test))
	
	if OS.get_unique_id() == DONUT:
		GATEWAY_SERVER_IP = SERVER_IP_LOCAL
	else:
		GATEWAY_SERVER_IP = SERVER_IP_DONUT
	$ConnectionStatus.modulate = Color.red
	
	multiplayer.connect("connected_to_server", self, "_connected")
	multiplayer.connect("server_disconnected", self, "_disconnected")
	
	var _net = NetworkedMultiplayerENet.new()
	
	_net.create_client(GATEWAY_SERVER_IP, GATEWAY_SERVER_PORT)
	
	multiplayer.set_network_peer(_net)

func _connected():
	bConnected = true
	$ConnectionStatus.modulate = Color.green
	$VBoxContainer/Server.text = "Server Status: CONNECTED"
	
func _disconnected():
	bConnected = false
	$ConnectionStatus.modulate = Color.red
	$VBoxContainer/Server.text = "Server Status: DISCONNECTED"


func set_user_name(username):
	$VBoxContainer/Username.text = "Signed In As: %s" % username

func set_department_name(dept_name : String):
	$VBoxContainer/Department.text = "Main Department: %s" % dept_name.to_upper()

func set_member_status(membername : String):
	$VBoxContainer/Member.text = "Member Status: %s" % membername.to_upper()
