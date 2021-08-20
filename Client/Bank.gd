extends Control


func _ready() -> void:
	connect("visibility_changed", self, "_visibility_changed")


func _visibility_changed() -> void:
	rpc_id(1, "_initialize_view", SNetworkGlobal.logged_in_token)


remote func _initialize_view(dicts, total) -> void:
	
	for dict in dicts:

		var inst = preload("res://SimpleBankRecord.tscn").instance()

		$ScrollContainer/VBoxContainer.add_child(inst)

		inst.text = str(dict)
	
	$Total.text = "$ " + str(total)
