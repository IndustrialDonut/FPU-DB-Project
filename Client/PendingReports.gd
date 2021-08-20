extends Control

func _ready() -> void:
	connect("visibility_changed", self, "_visibility_changed")


func _visibility_changed() -> void:
	rpc_id(1, "_initialize_view", SNetworkGlobal.logged_in_token)

remote func _initialize_view(dict, total) -> void:
	$Username.text = dict["Username"]
	$EventName.text = dict["EventIdentifier"]
	$ReviewText.text = dict["ReviewText"]
	$Hours.text = str(dict["Hours"])
	$Dept.text = dict["Department"]
	$Remaining.text = str(total) + " Reports Pending"
