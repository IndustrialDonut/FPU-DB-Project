extends Node

remote func test():
	var id = multiplayer.get_rpc_sender_id()
	print("called")
	rpc_id(id, "testback")
