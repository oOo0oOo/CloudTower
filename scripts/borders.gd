extends Node2D


func _ready():
	var dude = utils.get_main_node().get_node("dude")
	if dude:
		dude.connect("failed", self, "_on_failed")

func _on_failed():
	hide()