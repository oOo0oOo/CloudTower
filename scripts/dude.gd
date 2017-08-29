extends RigidBody2D

var first_contact = true
var is_failed = false
signal failed

func _ready():
	set_fixed_process(true)
	connect("body_enter", self, "_on_body_enter")

func _fixed_process(delta):
	var score = int((get_height() + 10)/50)
	if score > game.score_current:
		game.score_current = score
	
	var x = get_pos().x
	if not x < 360 + 500:
		fail()
	elif not x > 360 - 500:
		fail()

func fail():
	if not is_failed:
		is_failed = true
		set_opacity(0.5)
		sound_manager.play("game_over")
		emit_signal("failed")

func _on_body_enter(other):
	if other.is_in_group("ground"):
		if first_contact:
			first_contact = false
		else:
			fail()

func get_height():
	return -get_pos().y - 230 + 1280