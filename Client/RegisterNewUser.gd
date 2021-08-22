extends Control

signal return_from_register

func _on_CompleteRegistration_pressed() -> void:
	if $VBoxContainer/UsernameText.text.length() > 5 and $VBoxContainer/PasswordText.text.length() > 5:
		if $VBoxContainer/PasswordText.text == $VBoxContainer/PasswordText2.text:
			
			rpc_id(1, "_try_register", 
				$VBoxContainer/UsernameText.text, 
				$VBoxContainer/PasswordText.text.sha256_text()
				)
				
		else:
			print("passwords not matching")
	else:
		print("username or pass too short")


remote func registration_result(message) -> void:
	print(message)
	if message:
		emit_signal("return_from_register")


func _on_Button_pressed() -> void:
	
	emit_signal("return_from_register")
