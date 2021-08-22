extends HBoxContainer


func set_event_name(_name):
	$Eventname.text = _name

func set_player_gross(gross):
	$Playergross.text = str(gross)

func set_fee(fee):
	$Fee.text = str(fee)

func set_player_net(net):
	$Playernet.text = str(net)

func set_total_gross(gross):
	$Totalgross.text = str(gross)
