extends Control


const sqlite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")

const db_path = "res://db_files/db_main"

var db : sqlite = sqlite.new()


var logged_in_as = null

onready var _pass = $Entry/HBoxContainer/TextPassword
onready var _user = $Entry/HBoxContainer/TextUsername

func _ready() -> void:
	db.path = db_path
	createEvents()

func _process(delta: float) -> void:
	if get_focus_owner() == _pass or get_focus_owner() == _user:
		if Input.is_action_just_pressed("ui_accept"):
			_login_pressed()


func createEvents() -> void:
	db.open_db()
	
	#db.query("DROP TABLE Events2;")
	
	print(db.query("CREATE TABLE IF NOT EXISTS Events (Username TEXT, Gross INTEGER, Fee INTEGER, Payout INTEGER, PRIMARY KEY(Username));"))
	
	#print(db.query("SELECT name FROM sqlite_master where type='table';"))
	#print(db.query_result)
	
	db.close_db()


func _login_pressed() -> void:
	$Entry/ButtonHint.hide()
	$Entry/ButtonNew.hide()
	$Entry/ButtonLogin.hide()
	
	# This timer is just to make it feel like it actually is connecting
	# for the user to feel more secure, lol.
	$UserDelay.connect("timeout", self, "_try_login")
	$UserDelay.start()


func _login_fail() -> void:
	$Entry/ButtonHint.show()
	$Entry/ButtonNew.show()
	$Entry/ButtonLogin.show()


func _try_login() -> void:
	db.open_db()
	
	var _user_string = _user.text
	var _pass_string = _pass.text
	
	db.query("SELECT Password FROM Credentials WHERE Username = '" + _user_string + "';")
	print(db.query_result)
	
	if db.query_result.size() == 1:
		if _pass_string == db.query_result[0]["Password"]:
			print("Login successful as " + _user_string)	
			#$OutputConsole.show()
			#$OutputConsole.text="Login success."
			_login_success(_user_string)
			
		else:
			print("Password Incorrect")
			_login_fail()
			#$OutputConsole.show()
			#$OutputConsole.text="Password Incorrect"
	elif db.query_result.size() == 0:
		print("No username matching")
		_login_fail()
		#$OutputConsole.show()
		#$OutputConsole.text="No Username Matching"
		
	db.close_db()


func _login_success(username) -> void:
	logged_in_as = username
	$Entry.hide()
	$Members.show()


func _on_HoursWorked_pressed() -> void:
	#$OutputConsole.text = "You've worked "
	
	db.open_db()
	db.query("SELECT Hours FROM MemberData WHERE Username = '" + logged_in_as + "';")
	
	var hours = db.query_result[0]["Hours"]
	
	#$OutputConsole.text += str(hours) + " hours."
	
	db.close_db()


func pay() -> void:
	pass
