extends Control


var logged_in_token = null

onready var _pass = $Entry/HBoxContainer/TextPassword
onready var _user = $Entry/HBoxContainer/TextUsername

var net = NetworkedMultiplayerENet.new()
func _ready() -> void:
	$ConnectionStatus.modulate = Color.red
	
	get_tree().connect("connected_to_server", self, "_connected")
	get_tree().connect("server_disconnected", self, "_disconnected")
	
	var _error = net.create_client("10.0.0.8", 4399)
	
	get_tree().set_network_peer(net)

func _connected():
	$ConnectionStatus.modulate = Color.green
func _disconnected():
	$ConnectionStatus.modulate = Color.red
	get_tree().network_peer = null
	net = NetworkedMultiplayerENet.new()
	net.create_client("10.0.0.8", 4399)
	get_tree().network_peer = net
	

func _process(delta: float) -> void:
	#print(net.get_connection_status())
	
	# lets you hit enter to login.
	if get_focus_owner() == _pass or get_focus_owner() == _user:
		if Input.is_action_just_pressed("ui_accept"):
			_login_pressed()


func _login_pressed() -> void:
	$Entry/ButtonHint.hide()
	$Entry/ButtonNew.hide()
	$Entry/ButtonLogin.hide()
	
	# This timer is just to make it feel like it actually is connecting
	# for the user to feel more secure, lol.
	$UserDelay.connect("timeout", self, "_try_login")
	$UserDelay.start()


func _try_login() -> void:

	var _user_string = _user.text
	var _pass_string = _pass.text
	
	rpc_id(1, "_try_login", get_tree().get_network_unique_id(), _user_string, _pass_string.sha256_text())


remote func login_success(token) -> void:
	#print("login success with token " + token)
	logged_in_token = token
	$Entry.hide()
	$Members.show()


remote func login_fail(message) -> void:
	$Entry/ButtonHint.show()
	$Entry/ButtonNew.show()
	$Entry/ButtonLogin.show()
	print(message)


func _on_NetworkCheck_timeout() -> void:
	if not get_tree().get_network_connected_peers():
		$Entry.hide()
		$SERVERDOWN.show()


func _on_ButtonNew_pressed() -> void:
	$Entry.hide()
	$Register.show()

# try to register
func _on_Register_registration_submitted(_user_text, _pass_hashed) -> void:
	rpc_id(1, "_try_register", _user_text, _pass_hashed)


remote func registration_result(message) -> void:
	print(message)
	if message:
		$Register.hide()
		$Entry.show()
		


func _on_Members_event_form_submit(event, leader, review, gross, hours, dept) -> void:
	rpc_id(1, "_try_submit_event", logged_in_token, event, leader, review, gross, hours, dept)


remote func event_report_result(message) -> void:
	print(message)
	if message:
		pass


func _on_Members_bank_viewed() -> void:
	pass # Replace with function body.


remote func bank_data_result(data) -> void:
	pass
