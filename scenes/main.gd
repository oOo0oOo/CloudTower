extends Node

func _ready():
	get_tree().set_auto_accept_quit(false)

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		# Change to menu stage
		stage_manager.change_stage(stage_manager.STAGE_MENU)