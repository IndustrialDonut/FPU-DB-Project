extends Control


const sqlite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")

const db_path = "res://db_files/db_main"

var db : sqlite = sqlite.new()



func _on_ButtonLogin_pressed() -> void:
	
	db.path = db_path
	db.open_db()
	
	var _user_string = $TextUsername.text
	var _pass_string = $TextPassword.text
	
	print(db.query("SELECT Password FROM Credentials WHERE Username = '" + _user_string + "';"))
	
	if db.query_result.size() == 1:
		if _pass_string == db.query_result[0]["Password"]:
			print("Login successful as " + _user_string)	
			print("Password Incorrect")
			$OutputConsole.show()
			$OutputConsole.text="Password Correct"
		else:
			print("Password Incorrect")
			$OutputConsole.show()
			$OutputConsole.text="Password Incorrect"
	elif db.query_result.size() == 0:
		print("No username matching")
		print("Password Incorrect")
		$OutputConsole.show()
		$OutputConsole.text="No Username Matching"
		
	
	
