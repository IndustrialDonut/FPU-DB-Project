extends HBoxContainer

func set_labels(dict):
	
	$Username.text = dict["Username"]
	
	#$.text = dict["Username"]
	
	$Money.text = str(dict["NetPayment"])
