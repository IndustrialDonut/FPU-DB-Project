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
	db.query("SELECT Password FROM Credentials WHERE Username = '" + user + "';")
	db.close_db()
	
	if db.query_result.size() == 0:
		return Enums.VER.NOUSER
		
	elif db.query_result.size() == 1:
		if pass_h == db.query_result[0]["Password"]:
			
			return _admin_check(user)
			
		else:
			return Enums.VER.UNVERIFIED
		
	else:
		# means there were multiple user entries with the same username, shouldn't be possible.
		return -1



func _admin_check(user) -> int:
	db.open_db()
	db.query("SELECT Admin FROM Credentials WHERE Username='" + user + "';")
	db.close_db()
	
	if db.query_result[0]["Admin"] == 1:
		return Enums.VER.VERIFIED_WHITELISTED
	else:
		return Enums.VER.VERIFIED



func submit_event_report(dict) -> bool:
	var id = multiplayer.get_rpc_sender_id()
	var user = SNetworkGlobal.idToUsername(id)
	
	dict["Username"] = user
	
	db.open_db()
	
	var bInserted = db.insert_row("EventReports", dict)
	
	db.close_db()
	
	return bInserted


func view_pending_reports():
	db.open_db()
	
	db.query("SELECT * FROM EventReports WHERE Approved = 0;")
	
	var result = db.query_result
	
	db.close_db()
	
	return result


func view_approved_reports():
	db.open_db()
	
	db.query("SELECT * FROM EventReports WHERE Approved = 1;")
	
	var result = db.query_result
	
	db.close_db()
	
	return result


func view_bank_reports():
	db.open_db()
	
	db.query("SELECT EventIdentifier as Event, EventLeader as Leader, Username as Member, Gross, Hours, Department, OwedToPlayer FROM EventReports WHERE Approved = 1;")
	
	var result = db.query_result
	
	db.close_db()
	
	return result


func get_event_labels():
	db.open_db()
	
	# This SQL command actually ended up WORKING exactly right, however, I had already spent
	# 4 + hours working on a sorting algorithm by Datetime and would rather kill myself
	# than not use it after realizing this anyway. So, that sorting algorithm is 
	# on the Sorter class on the Event Report for the Client!
	db.query("SELECT EventName, Leader, Datetime, ID FROM Events ORDER BY Datetime")
	
	var result = db.query_result
	
	db.close_db()
	
	result.invert()
	
	return result


func pending_reports_for(id):
	db.open_db()
	
	var b = db.query("""SELECT * FROM
		(SELECT * FROM Events INNER JOIN EventReports 
		ON Events.ID = EventReports.EventID 
		ORDER BY Events.ID)
	WHERE EventID = """ + str(id) + ' AND Approved = 0;')

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
	WHERE EventID =""" + str(id) + ';')
	
	assert(b)
	
	var result = db.query_result
	
	db.close_db()
	
	return result.size()


func delete_report(id):
	db.open_db()
	
	assert(typeof(id) == typeof(5))
	
	var condition = "ReportID" + " = " + str(id)
	#print(condition)
	#print("ReportID = 3")
	
	print(db.delete_rows("EventReports", condition))
	
	db.close_db()
	

func approve_report(id):
	db.open_db()
	
	db.query("""UPDATE EventReports
	SET Approved = 1
	WHERE ReportID = """ + str(id))
	
	db.close_db()


const SC_TRANSFER_FEE = 0.005 # 0.5% fee rate
const ORG_DIVIDEND_RATE = 0.5 # ORG TAKES HALF
const PLAYER_DIVIDEND_RATE = 0.5 # PLAYERS TAKE HALF
func payout_event_id(id):
	print("event id for payout is " + str(id))
	db.open_db()
	
	db.query("SELECT HasBeenPaid FROM Events WHERE ID = " + str(id))
	
	if db.query_result[0]["HasBeenPaid"]:
		return
	
	#SUM(Gross) as Sum
	
	db.query("""
	SELECT * FROM EventReports
	WHERE Approved = 1 AND EventID = """ + str(id)
	+ " GROUP BY Username")
	
	var result = db.query_result.duplicate(true)
	
	var total_gross : float = 0
	var total_hours : float = 0
	for record in result:
		total_gross += record["Gross"]
		total_hours += record["Hours"]
	
	var total_players = result.size()
	
	var total_initial_fee = total_gross * SC_TRANSFER_FEE
	
	var pre_payment_total = total_gross - total_initial_fee
	
	var org_gross = pre_payment_total * ORG_DIVIDEND_RATE
	var players_net = pre_payment_total * PLAYER_DIVIDEND_RATE
	
	var org_net = org_gross - (players_net * SC_TRANSFER_FEE)
	
	var player_each_net = float(players_net) / float(total_players)
	
	var gross_to_hours : float = total_gross / total_hours
	
	var b = db.query("""
	UPDATE Events
	SET HasBeenPaid = 1, TotalGrossed = """ + str(total_gross) +
	", GrossedToHours = " + str(gross_to_hours) +
	""" WHERE ID = """ + str(id))
	
	assert(b)
	
	for i in range(total_players):
		
		var row = {
			"Username" : result[i]["Username"],
			"Grossed" : result[i]["Gross"],
			"PlayerNet" : player_each_net,
			"OrgNet" : org_net,
			"EventID" : result[i]["EventID"],
			"GrossToHours" : (result[i]["Gross"] / result[i]["Hours"])
		}
		
		b = db.insert_row("PayRecords", row)
		assert(b)
		print("pay record???")
	
	db.close_db()



func get_pay_records_for(id):
	var user = SNetworkGlobal.idToUsername(id)
	
	db.open_db()
	
	var b = db.query("""
	SELECT * FROM PayRecords INNER JOIN Events ON PayRecords.EventID = Events.ID 
	WHERE HasBeenPaid = 1 AND PayRecords.Username = '""" + user + "'"
	)
	
	assert(b)
	
	var result = db.query_result
	
	db.close_db()
	
	return result
