extends Control

onready var _pass = find_node("TextPassword")
onready var _user = find_node("TextUsername")

# lets you hit the enter key to login.
func _process(delta: float) -> void:
	if get_focus_owner() == _pass or get_focus_owner() == _user:
		if Input.is_action_just_pressed("ui_accept"):
			_login_pressed()


# This times a delay to make it feel like it takes time to connect.
func _login_pressed() -> void:
	if SNetworkGlobal.bConnected:
		#$Buttons1.hide()
		#$Buttons2.hide()
		
		$UserDelay.connect("timeout", self, "_try_login")
		$UserDelay.start()
	else:
		print("not connected")


# This is what fires after the user experience timer delay.
# Hash and send user and pass to gateway, try to login.
func _try_login() -> void:
	var _user_string = _user.text
	var _pass_string = _pass.text
	
	rpc_id(1, "_try_login", _user_string, _pass_string.sha256_text())


# Methods for server to report login attempt status
remote func login_success(message, member_stat, dept_name) -> void:
	$Entry.hide()
	$Members.show()
	print(message)
	SNetworkGlobal.set_department_name(dept_name)
	SNetworkGlobal.set_member_status(member_stat)
	SNetworkGlobal.set_user_name(_user.text)


remote func login_fail(message) -> void:
	#$Buttons1.show()
	#$Buttons2.show()
	print(message)


# Button to make new account
func _on_ButtonNew_pressed() -> void:
	$Entry.hide()
	$Register.show()


func _close_Register_View() -> void:
	$Entry.show()
	$Register.hide()

