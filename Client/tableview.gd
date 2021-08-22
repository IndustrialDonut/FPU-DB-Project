extends Control


func _ready() -> void:
	connect("visibility_changed", self, "_visibility_changed")


func _visibility_changed() -> void:
	rpc_id(1, "_initialize_records")


remote func _initialize_records(records):
	for child in $ScrollContainer/VBoxContainer.get_children():
		child.free()
	
	for record in records:
		var inst = preload("res://PayslipRecord.tscn").instance()
		
		$ScrollContainer/VBoxContainer.add_child(inst)
		
		inst.set_player_gross(record["Grossed"])
		inst.set_player_net(record["PlayerNet"])
		inst.set_total_gross(record["TotalGrossed"])
		inst.set_event_name(record["EventName"])
		inst.set_fee("FEE VIEW TO DO")
