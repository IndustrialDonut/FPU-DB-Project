extends Control


remote func _try_register(user_text, pass_hash):
	match Databaser.register(user_text, pass_hash):
		Enums.Register.REGISTER_SUCCESS:
			rpc_id(get_tree().get_rpc_sender_id(), "registration_result", "Success!")
		Enums.Register.USERNAME_TAKEN:
			rpc_id(get_tree().get_rpc_sender_id(), "registration_result", 0)



