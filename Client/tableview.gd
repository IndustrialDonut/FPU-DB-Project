extends Control


func _ready() -> void:
	connect("visibility_changed", self, "_visibility_changed")

var done = false
func _visibility_changed() -> void:
	if visible and not done:
		done = true
		rpc_id(1, "_initialize_records")


remote func _initialize_records(records):
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
	for record in records:
		# We are only showing for 1 user here, the person logged in.
		# There is only 1 event joined per 1 payrecord therefore, since it's
		# just per user. The database itself is not a 1-1 relationship, but
		# we here do not have to worry about duplicate events for the user
		# filter reason.
		
		# 'records' is a joined table between events and payrecords
		# 'GrossToHours' is on payrecord table, 'GrossedToHours' is on Events
		user_uec_hour += record["GrossToHours"]
		event_uec_hour += record["GrossedToHours"]
		
		var inst = preload("res://PayslipRecord.tscn").instance()
		
		$ScrollContainer/VBoxContainer.add_child(inst)
		
		$VBoxContainer/Username.text = record["Username"]
		
		inst.set_player_gross(record["Grossed"])
		totalplayercontri += record["Grossed"]
		inst.set_player_net(record["PlayerNet"])
		playernet += record["PlayerNet"]
		inst.set_total_gross(record["TotalGrossed"])
		overalltotalgross += record["TotalGrossed"]
		inst.set_event_name(record["EventName"])
		
		inst.set_fee(record["TotalGrossed"] * 0.005) # lol
		
		orgnet += record["OrgNet"]
		
		#total_hours += record["Hours"]
		
	
	var vbox = $HBoxContainer/VBoxContainer2
	
	var grosslabel = vbox.get_node("TotalPlayerGross").text
	vbox.get_node("TotalPlayerGross").text = grosslabel % str(totalplayercontri)
	
	var orgnetlabel = vbox.get_node("OrgNet").text
	vbox.get_node("OrgNet").text = orgnetlabel % str(orgnet)
	
	var grandtotallabel = vbox.get_node("GrandTotal").text
	vbox.get_node("GrandTotal").text = grandtotallabel % str(overalltotalgross)
	
	var playernetlabel = vbox.get_node("PlayerNet").text
	vbox.get_node("PlayerNet").text = playernetlabel % str(playernet)
	
	
	var commentlabel = $HBoxContainer/ScrollContainer2/VBoxContainer3/Comments.text
	$HBoxContainer/ScrollContainer2/VBoxContainer3/Comments.text = commentlabel % [str(user_uec_hour), str(event_uec_hour)]
	
	print(commentlabel % [str(user_uec_hour), str(event_uec_hour)])
	

signal return_from_invoice(node)
func _on_Button_pressed() -> void:
	emit_signal("return_from_invoice", self)
