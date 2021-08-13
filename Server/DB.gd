extends Node

const sqlite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")

const db_path = "res://db_files/db_main"

var db : sqlite = sqlite.new()


func _ready() -> void:
	print("test " + str(randi()))
	db.path = db_path
	#createEvents()


func authenticate(user, pass_h) -> int:
	db.open_db()
	db.query("SELECT Password FROM Credentials WHERE Username = '" + user + "';")
	db.close_db()
	
	if db.query_result.size() == 0:
		return Enums.Login.NO_USERNAME_FOUND
		
	elif db.query_result.size() == 1:
		if pass_h == db.query_result[0]["Password"]:
			return Enums.Login.LOGIN_OK
		else:
			return Enums.Login.PASSWORD_INCORRECT
	
	else:
		return -1


func register(user, pass_h):
	db.open_db()
	db.query("SELECT Username FROM Credentials;")
	db.close_db()
	
	for result in db.query_result:
		if result["Username"] == user:
			print("that username is taken")
			
			return Enums.Register.USERNAME_TAKEN
	
	print("username OK, registering")
	db.open_db()
	db.query("INSERT INTO Credentials (Username, Password) VALUES ('" + user + "','" + pass_h + "');")
	db.close_db()
	
	return Enums.Register.REGISTER_SUCCESS


func admin_check(user) -> int:
	db.open_db()
	db.query("SELECT Admin FROM Credentials WHERE Username='" + user + "';")
	db.close_db()
	
	if db.query_result[0]["Admin"] == 1:
		return Enums.Verify.VERIFIED_WHITELISTED
	else:
		return Enums.Verify.VERIFIED


func submit_event_report(user, event_name, event_leader, review, gross_funds, hours, dept):
	db.open_db()
	
	db.query(
		"INSERT INTO EventReports (EventName, EventLeader, Username, Gross, "
		+ "Hours, Review, Department, Payout) VALUES ('"
		 + event_name + "','" + event_leader + "','" + user + "','" + gross_funds
		+ "','" + hours + "','" + review + "','" + dept + "';")
		
	db.close_db()

#db.query("SELECT Hours FROM MemberData WHERE Username = '" + logged_in_as + "';")

#func createEvents() -> void:
	#db.open_db()
	
	#db.query("DROP TABLE Events2;")
	
	#print(db.query("CREATE TABLE IF NOT EXISTS Events (Username TEXT, Gross INTEGER, Fee INTEGER, Payout INTEGER, PRIMARY KEY(Username));"))
	
	#print(db.query("SELECT name FROM sqlite_master where type='table';"))
	#print(db.query_result)
	
	#db.close_db()
