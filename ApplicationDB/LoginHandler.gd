extends Control


const sqlite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")

const db_path = "res://db_files/db_main"

var db : sqlite = sqlite.new()


var logged_in_as = null

func _ready() -> void:
	db.path = db_path
	createEvents()

func createEvents() -> void:
	db.open_db()
	
	#db.query("DROP TABLE Events2;")
	
	print(db.query("CREATE TABLE IF NOT EXISTS Events (Username TEXT, Gross INTEGER, Fee INTEGER, Payout INTEGER, PRIMARY KEY(Username));"))
	
	#print(db.query("SELECT name FROM sqlite_master where type='table';"))
	#print(db.query_result)
	
	db.close_db()

func _on_ButtonLogin_pressed() -> void:
	
	db.path = db_path
	db.open_db()
	
	var _user_string = $TextUsername.text
	var _pass_string = $TextPassword.text
	
	print(db.query("SELECT Password FROM Credentials WHERE Username = '" + _user_string + "';"))
	
	if db.query_result.size() == 1:
		if _pass_string == db.query_result[0]["Password"]:
			print("Login successful as " + _user_string)	
			$OutputConsole.show()
			$OutputConsole.text="Login success."
			logged_in_as = _user_string
			
			$TextPassword.hide()
			$TextUsername.hide()
			$ButtonLogin.hide()
			$HoursWorked.show()
			
		else:
			print("Password Incorrect")
			$OutputConsole.show()
			$OutputConsole.text="Password Incorrect"
	elif db.query_result.size() == 0:
		print("No username matching")
		$OutputConsole.show()
		$OutputConsole.text="No Username Matching"
		
	db.close_db()


func _on_HoursWorked_pressed() -> void:
	$OutputConsole.text = "You've worked "
	
	db.open_db()
	db.query("SELECT Hours FROM MemberData WHERE Username = '" + logged_in_as + "';")
	
	var hours = db.query_result[0]["Hours"]
	
	$OutputConsole.text += str(hours) + " hours."
	
	db.close_db()


func pay() -> void:
	pass
