extends Control

signal registration_submitted(_user_text, _pass_hashed)

func _on_CompleteRegistration_pressed() -> void:
	if $VBoxContainer/UsernameText.text.length() > 5 and $VBoxContainer/PasswordText.text.length() > 5:
		if $VBoxContainer/PasswordText.text == $VBoxContainer/PasswordText2.text:
			emit_signal("registration_submitted", $VBoxContainer/UsernameText.text, $VBoxContainer/PasswordText.text.sha256_text())
		else:
			print("passwords not matching")
	else:
		print("username or pass too short")
