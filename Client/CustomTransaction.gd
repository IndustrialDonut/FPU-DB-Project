extends HBoxContainer

func set_labels(dict : Dictionary):
	
	if dict["bPersonal"]:
		$From.text = dict["FromUser"]
	else:
		$From.text = dict["FromDept"]
	
	$To.text = dict["Recipient"]
	
	$Reason.text = dict["Reason"]
	
	$Payment.text = dict["Payment"] as String
