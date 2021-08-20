extends Node

const sqlite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")

const db_path = "res://db_files/db_main"

var db : sqlite = sqlite.new()


func _ready() -> void:
	db.path = db_path


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
