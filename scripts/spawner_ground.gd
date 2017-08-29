extends Node

const ground_scn = preload("res://scenes/ground.tscn")

func _ready():
	# Create ground elements
	var n_elements = 7
	for i in range(n_elements):
		var x = -(720) * int(n_elements/2) + i * 720
		var ground = ground_scn.instance()
		ground.set_pos(Vector2(x, 0))
		add_child(ground)
	
	var dude = utils.get_main_node().get_node("dude")
	if dude:
		dude.connect("failed", self, "_on_failed")

func _on_failed():
	set_opacity(0.5)
	
func set_collision(enabled, platform):
	for ground in get_children():
		if not enabled:
			platform.add_collision_exception_with(ground)
		else:
			platform.remove_collision_exception_with(ground)
