extends HBoxContainer

func set_labels(dict : Dictionary):
	
	$From.text = dict["From"]
	
	$To.text = dict["Recipient"]
	
	$Reason.text = dict["Reason"]
	
	$Gross.text = dict["Gross"]
