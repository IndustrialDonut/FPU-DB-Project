extends Control


func _ready() -> void:
	connect("visibility_changed", self, "_visibility_changed")

#var done = false
func _visibility_changed() -> void:
	#if visible and not done:
		#done = true
	rpc_id(1, "_initialize_records")


remote func _initialize_records(records : Array):
	for i in $ScrollContainer/VBoxContainer.get_child_count():
		if i > 0:
			$ScrollContainer/VBoxContainer.get_child(i).queue_free()
	
	var total_hours = 0
	
	var totalplayercontri = 0
	var playernet = 0
	var orgnet = 0
	var overalltotalgross = 0
	
	var user_uec_hour = 0
	var event_uec_hour = 0
	
	var my_records = []
	
	for record in records:
		if record["Username"] == SNetworkGlobal.username:
			my_records.append(record)
	
	for record in my_records:
		# We are only showing for 1 user here, the person logged in.
		# There is only 1 event joined per 1 payrecord therefore, since it's
		# just per user. The database itself is not a 1-1 relationship, but
		# we here do not have to worry about duplicate events for the user
		# filter reason.
		
		# 'records' is a joined table between events and payrecords
		# 'GrossToHours' is on payrecord table, 'GrossedToHours' is on Events
		#user_uec_hour += record["GrossToHours"]
		#event_uec_hour += record["GrossedToHours"]
		
		var inst = preload("res://PayslipRecord.tscn").instance()
		
		$ScrollContainer/VBoxContainer.add_child(inst)
		
		$VBoxContainer/Username.text = record["Username"]
		
		#inst.set_player_gross(record["Grossed"])
		#totalplayercontri += record["Grossed"]
		inst.set_player_net(record["NetPayment"])
		playernet += record["NetPayment"]
		#inst.set_total_gross(record["TotalGrossed"])
		#overalltotalgross += record["TotalGrossed"]
		#inst.set_event_name(record["EventName"])
		
		#inst.set_fee(record["TotalGrossed"] * 0.005) # lol
		
		#orgnet += record["OrgNet"]
		
		#total_hours += record["Hours"]
		
	

signal return_from_invoice(node)
func _on_Button_pressed() -> void:
	emit_signal("return_from_invoice", self)
