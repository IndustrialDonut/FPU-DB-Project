extends Control


func _ready() -> void:
	connect("visibility_changed", self, "_visibility_changed")


func _visibility_changed() -> void:
	rpc_id(1, "_initialize_view")


remote func _initialize_view(dicts, total) -> void:
	
	for dict in dicts:

		var inst = preload("res://SimpleBankRecord.tscn").instance()

		$ScrollContainer/VBoxContainer.add_child(inst)

		inst.text = str(dict)
	
	$Total.text = "$ " + str(total)


signal _return_bank
func _on_Back_pressed() -> void:
	emit_signal("_return_bank")
