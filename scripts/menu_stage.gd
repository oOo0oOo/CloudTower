extends Node2D


func _ready():
	get_tree().set_auto_accept_quit(true)
	get_node("score_label").set_text("Best:   " + str(game.score_best))
	pass
