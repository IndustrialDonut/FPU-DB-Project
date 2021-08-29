extends Node

const sqlite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")

const db_path = "res://db_files/db_main"

var db : sqlite = sqlite.new()


func _ready() -> void:
	db.path = db_path


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
	db.query("INSERT INTO Users (Username) VALUES ('" + user + "')")
	db.close_db()

	return Enums.Register.REGISTER_SUCCESS


func authenticate(user, pass_h) -> int:
	db.open_db()
	db.query("SELECT Password, Active FROM Credentials WHERE Username = '" + user + "'")
	db.close_db()
	
	if db.query_result.size() == 0:
		return Enums.VER.NOUSER
		
	elif db.query_result.size() == 1:
		if pass_h == db.query_result[0]["Password"]:
			
			if db.query_result[0]["Active"] == 1:
			
				return _admin_check(user)
				
			else:
				# User not activated yet.
				return Enums.VER.INACTIVE
			
		else:
			# Wrong password to sign in.
			return Enums.VER.WRONGPASS
		
	else:
		# Multiple user entries with the same username, shouldn't be possible.
		return -1


func _admin_check(user) -> int:
	db.open_db()
	db.query("SELECT Admin FROM Credentials WHERE Username='" + user + "'")
	db.close_db()
	
	if db.query_result[0]["Admin"] == 1:
		return Enums.VER.VERIFIED_WHITELISTED
	else:
		return Enums.VER.VERIFIED


func member_status(_user) -> String:
	db.open_db()
	db.query("SELECT Member FROM Credentials WHERE Username = '" + str(_user) + "'")
	db.close_db()
	
	return db.query_result[0]["Member"]


func member_department(_user) -> String:
	db.open_db()
	db.query("SELECT Department FROM Credentials WHERE Username = '" + str(_user) + "'")
	db.close_db()
	
	return db.query_result[0]["Department"]


func submit_event_report(dict) -> bool:
	var id = multiplayer.get_rpc_sender_id()
	var user = SNetworkGlobal.idToUsername(id)
	
	dict["Username"] = user
	
	dict["Datetime"] = _format_datetime(OS.get_datetime())
	
	var eventID = dict["EventID"]
	
	db.open_db()
	
	# Do not allow submitting a report to an event that has already been committed.
	db.query("SELECT Committed FROM Events WHERE COMMITTED = 1 AND ID = " + str(eventID))
	
	var eventAlreadyCommitted = db.query_result.size()
	
	if eventAlreadyCommitted:
		db.close_db()
		return false
	
	# Do not allow players to submit more than 1 event report.
	db.query("SELECT * FROM EventReports WHERE Username = '" + user + "' AND EventID = " + str(eventID))
	
	var bInserted
	
	if db.query_result.size() == 0:
	
		bInserted = db.insert_row("EventReports", dict)
	
	db.close_db()
	
	return bInserted


# use OS.get_datetime() with this one for example
func _format_datetime(dict):
	var string = dict["year"] as String
	
	string += ":"
	
	if dict["month"] < 10:
		string += "0"
	
	string += dict["month"] as String
	
	string += ":"
	
	if dict["day"] < 10:
		string += "0"
	
	string += dict["day"] as String
	
	string += ":"
	
	if dict["hour"] < 10:
		string += "0"
	
	string += dict["hour"] as String
	
	string += ":"
	
	if dict["minute"] < 10:
		string += "0"
	
	string += dict["minute"] as String
	
	return string


func view_pending_reports():
	db.open_db()
	
	db.query("SELECT * FROM EventReports WHERE Approved = 0")
	
	var result = db.query_result
	
	db.close_db()
	
	return result


func view_approved_reports():
	db.open_db()
	
	db.query("SELECT * FROM EventReports WHERE Approved = 1")
	
	var result = db.query_result
	
	db.close_db()
	
	return result


func view_bank_custom_transactions():
	db.open_db()
	
	#db.query("SELECT EventIdentifier as Event, EventLeader as Leader, Username as Member, Gross, Hours, Department, OwedToPlayer FROM EventReports WHERE Approved = 1")
	
	db.query("SELECT * FROM CustomTransactions")
	
	var result = db.query_result
	
	db.close_db()
	
	return result


func get_event_labels():
	db.open_db()
	
	# This SQL command actually ended up WORKING exactly right, however, I had already spent
	# 4 + hours working on a sorting algorithm by Datetime and would rather kill myself
	# than not use it after realizing this anyway. So, that sorting algorithm is 
	# on the Sorter class on the Event Report for the Client!
	db.query("SELECT EventName, Leader, Datetime, ID FROM Events WHERE Committed = 0 ORDER BY Datetime")
	
	var result = db.query_result
	
	db.close_db()
	
	result.invert()
	
	return result


func pending_reports_for(eventId):
	db.open_db()
	
	var b = db.query("""
	SELECT EventID, ReportID AS ID, Username, ReviewScore, ReviewText, Department, Gross, Hours
	FROM
		(SELECT EventReports.ID AS ReportID, Events.ID AS EventID, Approved, Username, ReviewScore, Department, Gross, Hours, ReviewText FROM Events INNER JOIN EventReports 
		ON Events.ID = EventReports.EventID 
		ORDER BY Events.ID)
	WHERE EventID = """ + str(eventId) + ' AND Approved = 0')

	assert(b)

	var result = db.query_result.duplicate(true)
	
	print(result)

	db.close_db()
	
	print(result.size())

	return result


func total_reports_for(id) -> int:
	db.open_db()
	
	var b = db.query("""SELECT * FROM
		(SELECT * FROM Events INNER JOIN EventReports 
		ON Events.ID = EventReports.EventID 
		ORDER BY Events.ID)
	WHERE EventID =""" + str(id))
	
	assert(b)
	
	var result = db.query_result
	
	db.close_db()
	
	return result.size()


# when a report is denied, this deletes it
func delete_report(id) -> bool:
	db.open_db()
	
	assert(typeof(id) == typeof(5))
	
	var condition = "ID = " + str(id)
	
	var b = db.delete_rows("EventReports", condition)
	
	db.close_db()
	
	return b


func approve_report(id) -> bool:
	db.open_db()
	
	var b = db.query("""UPDATE EventReports
	SET Approved = 1
	WHERE ID = """ + str(id))
	
	_ratestamp_report(id)
	
	db.close_db()
	
	return b


func _ratestamp_report(report_id) -> bool:
	# only call from within the db.open and db.close scope of another func!
	db.query("SELECT Username FROM EventReports WHERE ID = " + str(report_id))
	var user = db.query_result[0]["Username"]
	
	db.query("SELECT Member FROM Credentials WHERE Username = '" + user + "'")
	var member = db.query_result[0]["Member"]
	
	db.query("SELECT MAX(ID) AS ID FROM MemberRates WHERE Enum = '" + str(member) + "'")
	var rateID = db.query_result[0]["ID"]
	
	var b = db.query("UPDATE EventReports SET RateID = " + str(rateID) + " WHERE ID = " + str(report_id))
	
	return b


func commit_event(id) -> bool:
	db.open_db()
	
	var b = db.query("""UPDATE Events
	SET Committed = 1
	WHERE ID = """ + str(id))
	
	db.close_db()
	
	return b

# only select paid event reports
func metadata_payrecords_paid(event_id : int) -> Array:
	var records
	
	db.open_db()
	
	db.query("""SELECT * FROM 
	EventReports INNER JOIN MemberRates 
	ON RateID = MemberRates.ID
	
	""")
	
	db.close_db()
	
	return records

# only allow this if an event has been committed!
func metadata_payrecords_to_pay(event_id : int) -> Array:
	var records
	
	db.open_db()
	
	db.query("""SELECT * FROM 
	EventReports INNER JOIN MemberRates 
	ON RateID = MemberRates.ID 
	WHERE EventID = """ + str(event_id))
	
	# I now have all the rate and event report info FOR A PARTICULAR EVENT,
	# so I can loop over and do the sum and avg and that whole process now.
	var result = db.query_result
	
	db.close_db()
	
	
	var orgnet = 0
	var paypool = 0
	for record in result:
		var gross = record["Gross"]
		var taxrate = record["Tax"]
		var transferrate = record["Transfer"]
		
		var transfer_loss = gross * transferrate
		
		var incoming = gross - transfer_loss
		
		orgnet += incoming * taxrate
		paypool += incoming * (1 - taxrate)
		
		# this actually might not make sense without a weighted average
		# if people are taxed at different rates.
		
	
	return records


func insert_event(dict) -> bool:
	db.open_db()
	
	var b = db.insert_row("Events", dict)
	
	db.close_db()
	
	return b


func submit_custom_transaction(dict) -> bool:
	db.open_db()
	
	var b = db.insert_row("CustomTransactions", dict)
	
	db.close_db()
	
	return b
