extends Node

const scn_platform = preload("res://scenes/platform.tscn")
var last_platform

func _ready():
	spawn_platform()
	
	var dude = utils.get_main_node().get_node("dude")
	if dude:
		dude.connect("failed", self, "_on_failed")

func spawn_platform():
	last_platform = scn_platform.instance()
	add_child(last_platform)

func _on_failed():
	for p in get_children():
		p.set_opacity(0.5)
	last_platform.hide()