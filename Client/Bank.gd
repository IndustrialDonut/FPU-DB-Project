extends Control


func _ready() -> void:
	connect("visibility_changed", self, "_visibility_changed")


func _visibility_changed() -> void:
	rpc_id(1, "_initialize_view")


remote func _initialize_view(dicts, total) -> void:

	for dict in dicts:

		var inst = preload("res://CustomTransaction.tscn").instance()

		$ScrollContainer/VBoxContainer.add_child(inst)

		inst.set_labels(dict)

	$BankTotal.text = $BankTotal.text % total as String


signal _return_bank(node)
func _on_Back_pressed() -> void:
	emit_signal("_return_bank", self)


func _on_Submit_pressed() -> void:
	var dict = {}
	
	dict["Recipient"] = $VBoxContainer2/Recipient.text
	
	dict["Gross"] = $VBoxContainer2/Gross.text.to_int()
	
	dict["Reason"] = $VBoxContainer2/Reason.text
	
	var bPersonal = $VBoxContainer2/HBoxContainer/Personal.pressed
	
	dict["bPersonal"] = bPersonal
	
	rpc_id(1, "_submit_custom_transaction", dict, bPersonal)


remote func _result(result):
	print(result)
