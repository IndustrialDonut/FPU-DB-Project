extends Control

signal return_from_register

func _on_CompleteRegistration_pressed() -> void:
	
	if $VBoxContainer2/HBoxContainer/AgreeBox.pressed:
	
		if $VBoxContainer2/UsernameText.text.length() > 5 and $VBoxContainer2/PasswordText.text.length() > 5:
			if $VBoxContainer2/PasswordText.text == $VBoxContainer2/PasswordText2.text:
				
				rpc_id(1, "_try_register", 
					$VBoxContainer2/UsernameText.text, 
					$VBoxContainer2/PasswordText.text.sha256_text()
					)
					
			else:
				print("Passwords not matching.")
		else:
			print("Username or Password too short.")
	else:
		print("You must agree to the rules and regulations to make an account.")


remote func registration_result(bResult) -> void:
	if bResult:
		emit_signal("return_from_register")
		print("You account was successfuly registered and is now pending activation, an admin will activate your account soon.")


func _on_Button_pressed() -> void:
	
	emit_signal("return_from_register")
