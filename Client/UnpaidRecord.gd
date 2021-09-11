extends HBoxContainer

signal pressed_pay(my_name)

func set_labels(dict):
	
	$Username.text = dict["Username"]
	
	#$.text = dict["Username"]
	
	$Money.text = str(dict["NetPayment"])



func _on_Button_pressed() -> void:
	emit_signal("pressed_pay", $Username.text)
