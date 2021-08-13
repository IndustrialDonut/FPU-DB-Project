extends Control

# For time being, this is both authenticator/gateway/db and everything server-side.
# Later on we can have a separate project for just the gateway and others as needed.

var _user_token_dictionary = {1 : {"user" : "SERVER" , "token" : null}}

func _ready() -> void:
	var net = NetworkedMultiplayerENet.new()
	net.create_server(8766, 400)
	get_tree().set_network_peer(net)
	
	get_tree().connect("network_peer_connected", self, "_user_connected")
	get_tree().connect("network_peer_disconnected", self, "_user_disconnected")


func _user_connected(id) -> void:
	_user_token_dictionary[id] = null


func _user_disconnected(id) -> void:
	_user_token_dictionary.erase(id)


remote func _try_register(user_text, pass_hash):
	match $DB.register(user_text, pass_hash):
		Enums.Register.REGISTER_SUCCESS:
			rpc_id(get_tree().get_rpc_sender_id(), "_registration_result", "Success!")
		Enums.Register.USERNAME_TAKEN:
			rpc_id(get_tree().get_rpc_sender_id(), "_registration_result", 0)


remote func _try_login(id : int, _user : String, _pass : String):
	match $DB.authenticate(_user, _pass):
		Enums.Login.LOGIN_OK:
			_user_token_dictionary[id] = {"user" : _user , "token" : _generate_new_token()}
			rpc_id(id, "_login_success", _user_token_dictionary[id]["token"])
		Enums.Login.NO_USERNAME_FOUND:
			rpc_id(id, "_login_fail", "No matching username found.")
		Enums.Login.PASSWORD_INCORRECT:
			rpc_id(id, "_login_fail", "Password incorrect.")
		_:
			rpc_id(id, "_login_fail", "Something went hella wrong on our end, tell Donut.")
			assert(0)


func _generate_new_token() -> String:
	randomize()
	var token = str(randi()) + str(OS.get_unix_time())
	return token


func _verify_status(id, token) -> int:
	if _user_token_dictionary.has(id):
		if _user_token_dictionary[id]["token"] == token:
			return $DB.admin_check(_user_token_dictionary[id]["user"])
		else:
			return Enums.Verify.UNVERIFIED
	else:
		return Enums.Verify.UNVERIFIED


remote func _try_submit_event(token, event_name, event_leader, review, gross_funds, hours, dept):
	var status = _verify_status(get_tree().get_rpc_sender_id(), token)
	var user = _user_token_dictionary[get_tree().get_rpc_sender_id()]["user"]
	if status == Enums.Verify.UNVERIFIED:
		# did not submit
		rpc_id(get_tree().get_rpc_sender_id(), "_event_report_result", 0)
	else:
		# submit
		if $DB.submit_event_report(user, event_name, event_leader, review, gross_funds, hours, dept):
			# reported successfuly
			rpc_id(get_tree().get_rpc_sender_id(), "_event_report_result", "Submit success.")
		else:
			rpc_id(get_tree().get_rpc_sender_id(), "_event_report_result", 0)
