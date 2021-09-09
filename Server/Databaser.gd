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
	db.query("SELECT Committed FROM Events WHERE Committed = 1 AND ID = " + str(eventID))
	
	var eventAlreadyCommitted = db.query_result.size()
	
	if eventAlreadyCommitted:
		db.close_db()
		return false
	
	# Do not allow players to submit more than 1 event report.
	#db.query("SELECT * FROM EventReports WHERE Username = '" + user + "' AND EventID = " + str(eventID))
	
	#var bInserted = false
	
	#if db.query_result.size() == 0:
	
	var bInserted = db.insert_row("EventReports", dict)
	
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


func get_bank_custom_transactions() -> Array:
	db.open_db()
	
	#db.query("SELECT EventIdentifier as Event, EventLeader as Leader, Username as Member, Gross, Hours, Department, OwedToPlayer FROM EventReports WHERE Approved = 1")
	
	db.query("SELECT * FROM CustomTransactions")
	
	var result = db.query_result
	
	db.close_db()
	
	return result.duplicate(true)


# bad because this is not using generated-metadata as we want to do
#func get_paid_payrecords():
#	db.open_db()
#
#	db.query("SELECT * FROM PayRecords")
#
#	var result = db.query_result
#
#	db.close_db()
#
#	return result


func get_event_labels(username = false):
	db.open_db()
	
	# if the function is being called to request labels for the report submission
	# screen, then this control block will be executed as a username will be passed.
	if username:
		
		db.query("""SELECT * FROM 
		(SELECT EventName, Leader, Events.Datetime, Events.ID, Username FROM 
		Events LEFT JOIN EventReports ON Events.ID = EventReports.EventID 
		WHERE Committed = 0)""")
		
		var do_not_show_these_event_names = []
		var remove_these_records = []
		for record in db.query_result:
			if record["Username"]:
				if record["Username"] as String == username:
					do_not_show_these_event_names.append(record["EventName"])
		
		for record in db.query_result:
			if record["EventName"] in do_not_show_these_event_names:
				remove_these_records.append(record)
		
		for remove in remove_these_records:
			db.query_result.erase(remove)
	
	# otherwise, it's being called for the pending reports event labels. So, just
	# return all uncommitted events plain and simple.
	else:
		
		db.query("""SELECT EventName, Leader, Datetime, ID FROM Events WHERE Committed = 0 
		ORDER BY Datetime""")
	
	var result = db.query_result.duplicate(true)
	
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


# only consider an event if it has been committed!
# purely meta-data viewing!
func generate_payrecords_to_pay() -> Array:
	return _generate_metadata_payrecords(false)


func generate_paid_payrecords() -> Array:
	return _generate_metadata_payrecords(true)[0]


func generate_bank_cumulative_total() -> float:
	return _generate_metadata_payrecords(true)[1]


#func generate_personal_paid_records(id) -> Array:
#	return _generate_metadata_payrecords(true, id)[0]

# see Excel document for more info on the algorithm in pseudocode if you dare
func _generate_metadata_payrecords(already_paid : bool) -> Array:
	var records = []
	
	db.open_db()
	
	db.query("""SELECT * FROM 
	(SELECT Username, Gross, Hours, RateID, Paid, EventID as EventID, EventReports.ID AS ReportID FROM 
	EventReports INNER JOIN Events ON EventReports.EventID = Events.ID 
	WHERE Events.Committed = 1 AND EventReports.Paid = '""" + str(int(already_paid)) + """'  
	AND EventReports.Approved = 1) 
	INNER JOIN MemberRates ON MemberRates.ID = RateID""")
	
	var result = db.query_result.duplicate(true)
	
	var man_hours_dict = {}
	
	# initializing dictionary is all.
	for record in result:
		man_hours_dict[record["Enum"]] = 0
	
	var total_man_hours : float  = 0
	
	var TRANSFER_RATE : float
	
	var total_base_income : float = 0 #total_gross * (1.0 - TRANSFER_RATE) # 1 - transfer fee is transfer YIELD
	
	for record in result:
		
		TRANSFER_RATE = record["Transfer"] # this is NOT different per Member level,
			# it is just needed on each record for other purposes. It may change though
			# in time, which is why we record it with those entries anyway. But yeah,
			# don't be confused by this.
		
		total_base_income += floor( record["Gross"] * (1.0 - TRANSFER_RATE) )
		
		total_man_hours += record["Hours"]
		
		man_hours_dict[record["Enum"]] += record["Hours"]
		
	var total_org_loss : float = 0
	
	for record in result:
		
		var pay_record_entry = {}
		
		var contributed_hour_ratio : float = record["Hours"] / total_man_hours
		
		var base_outgoing_pay : float = contributed_hour_ratio * total_base_income
		
		var outgoing : float = base_outgoing_pay * (1 - record["Tax"]) # 1 - tax is payment YIELD
		
		var player_net_payment : float = 0
		
		var org_loss : float = 0
		
		if record["Enum"] == "Member":
			
			var received_pay : float = outgoing
			
			org_loss = ceil(received_pay * (1.0 / (1.0 - TRANSFER_RATE)))
			
			player_net_payment = floor(received_pay)
			
		else:
			
			org_loss = ceil(outgoing)
			
			var received_pay : float = floor(outgoing * (1.0 - TRANSFER_RATE))
			
			player_net_payment = received_pay
		
		total_org_loss += org_loss
		
		pay_record_entry["Username"] = record["Username"]
		pay_record_entry["NetPayment"] = player_net_payment
		pay_record_entry["OrgLoss"] = org_loss
		
		records.append(pay_record_entry)
	
	db.close_db()
	
	var total_org_profit = total_base_income - total_org_loss
	
	if already_paid:
		return [records.duplicate(true), total_org_profit]
	else:
		return records.duplicate(true)


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
