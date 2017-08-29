extends Node2D


func _ready():
	get_node("anim").play("idle")
	game.connect("score_best_changed", self, "_on_score_best_changed")
	reset_highscore()
	
	# Check for failed dude to hide
	var dude = utils.get_main_node().get_node("dude")
	if dude:
		dude.connect("failed", self, "_on_failed")

func _on_score_best_changed():
	reset_highscore()

func _on_failed():
	hide()

func reset_highscore():
	if game.score_best == 0:
		hide()
	else:
		set_pos(Vector2(0, 1050 - game.score_best * 50))
		show()
