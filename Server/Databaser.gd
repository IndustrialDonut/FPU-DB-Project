extends Node

const sqlite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")

const db_path = "res://db_files/db_main"

var db : sqlite = sqlite.new()


func _ready() -> void:
	db.path = db_path


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
	
	db.query("SELECT EventName, Leader, Datetime, ID FROM Events;")
	
	var result = db.query_result
	
	db.close_db()
	
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
	pass
