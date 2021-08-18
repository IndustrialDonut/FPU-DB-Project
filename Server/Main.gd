extends Control

# For time being, this is both authenticator/gateway/db and everything server-side.
# Later on we can have a separate project for just the gateway and others as needed.

var user_token_dictionary = {1 : {"user" : "SERVER" , "token" : null}}

var _batch_of_events = {}

func _ready() -> void:
	var net = NetworkedMultiplayerENet.new()
	net.create_server(4399, 400)
	get_tree().set_network_peer(net)
	
	get_tree().connect("network_peer_connected", self, "_user_connected")
	get_tree().connect("network_peer_disconnected", self, "_user_disconnected")
	
	#var string = "123,346,895"
	#string = string.to_int()
	#print(string)


func _user_connected(id) -> void:
	user_token_dictionary[id] = null


func _user_disconnected(id) -> void:
	user_token_dictionary.erase(id)





remote func _try_login(id : int, _user : String, _pass : String):
	match Databaser.authenticate(_user, _pass):
		Enums.Login.LOGIN_OK:
			user_token_dictionary[id] = {"user" : _user , "token" : _generate_new_token()}
			rpc_id(id, "login_success", user_token_dictionary[id]["token"])
		Enums.Login.NO_USERNAME_FOUND:
			rpc_id(id, "login_fail", "No matching username found.")
		Enums.Login.PASSWORD_INCORRECT:
			rpc_id(id, "login_fail", "Password incorrect.")
		_:
			rpc_id(id, "login_fail", "Something went hella wrong on our end, tell Donut.")
			assert(0)


func _generate_new_token() -> String:
	randomize()
	var token = str(randi()) + str(OS.get_unix_time())
	return token


func verify_status(id, token) -> int:
	if user_token_dictionary.has(id):
		if user_token_dictionary[id]["token"] == token:
			return Databaser.admin_check(user_token_dictionary[id]["user"])
		else:
			return Enums.Verify.UNVERIFIED
	else:
		return Enums.Verify.UNVERIFIED




remote func _approve_to_batch(token, report_id):
	if verify_status(get_tree().get_rpc_sender_id(), token) == Enums.Verify.VERIFIED_WHITELISTED:
		pass # approve it to the batch temporarily, then when the admin also
		# runs the batch calculation, it will be marked Approved.
		# if admin dc's before having run the calculation, the reports in the batch
		# will simply be removed from the temporary dictionary/array and remain
		# in the pending EventReports table as not yet approved.


remote func _run_batch_calculation(token):
	if verify_status(get_tree().get_rpc_sender_id(), token) == Enums.Verify.VERIFIED_WHITELISTED:
		pass


remote func _reject_report(token, report_id):
	if verify_status(get_tree().get_rpc_sender_id(), token) == Enums.Verify.VERIFIED_WHITELISTED:
		pass
