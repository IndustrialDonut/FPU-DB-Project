extends Control

onready var _pass = $Entry/HBoxContainer/TextPassword
onready var _user = $Entry/HBoxContainer/TextUsername

# lets you hit the enter key to login.
func _process(delta: float) -> void:
	if get_focus_owner() == _pass or get_focus_owner() == _user:
		if Input.is_action_just_pressed("ui_accept"):
			_login_pressed()


# This times a delay to make it feel like it takes time to connect.
func _login_pressed() -> void:
	if SNetworkGlobal.bConnected:
		$Entry/ButtonHint.hide()
		$Entry/ButtonNew.hide()
		$Entry/ButtonLogin.hide()
		
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
remote func login_success(message) -> void:
	$Entry.hide()
	$Members.show()
	print(message)


remote func login_fail(message) -> void:
	$Entry/ButtonHint.show()
	$Entry/ButtonNew.show()
	$Entry/ButtonLogin.show()
	print(message)


# Button to make new account
func _on_ButtonNew_pressed() -> void:
	$Entry.hide()
	$Register.show()


func _close_Register_View() -> void:
	$Entry.show()
	$Register.hide()

