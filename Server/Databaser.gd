extends Node

const sqlite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")

const db_path = "res://db_files/db_main"

var db : sqlite = sqlite.new()


func _ready() -> void:
	db.path = db_path


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


func submit_event_report(user, event_name, event_leader, review_text, gross_funds, hours, dept) -> bool:
	db.open_db()
	
	var bInserted = db.query(
		"INSERT INTO EventReports (EventIdentifier, EventLeader, Username, Gross, "
		+ "Hours, ReviewText, Department, OwedToPlayer, Approved) VALUES ('"
		 + event_name + "','" + event_leader + "','" + user + "'," + str(gross_funds)
		+ "," + str(hours) + ",'" + review_text + "','" + dept + "', 0," + "0" + ");"
		)
		
	db.close_db()
	
	return bInserted


func view_pending_reports():
	db.open_db()
	
	db.query("SELECT * FROM EventReports WHERE Approved = 0;")
	
	var result = db.query_result
	
	db.close_db()
	
	return result


func id_pull_report(report_id):
	pass

