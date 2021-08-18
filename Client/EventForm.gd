extends Control

signal event_submitted(event, leader, review, gross, hours, dept)

func _on_CompleteRegistration_pressed() -> void:
	if $UsernameText.text.length() > 5 and $PasswordText.text.length() > 5:
		if $PasswordText.text == $PasswordText2.text:
			emit_signal("registration_submitted", $UsernameText.text, $PasswordText.text.sha256_text())
		else:
			print("passwords not matching")
	else:
		print("username or pass too short")


func _on_Button_pressed() -> void:
	for child in get_children():
		if child is LineEdit:
			if not child.text.length() > 0:
				print("not all fields filled out")
				return
	
	emit_signal("event_submitted", $eventname.text, $leadername.text, $review.text, $gross.text, $hours.text.to_int(), $dept.text)
	
	$eventname.text = ""
	$leadername.text = ""
	$review.text = ""
	$gross.text = ""
	$hours.text = ""
	$dept.text = ""


func _on_returnbutton_pressed() -> void:
	get_parent().show()
	hide()
