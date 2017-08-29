extends CanvasLayer

const STAGE_GAME = "res://stages/Main.tscn"
const STAGE_MENU = "res://stages/menu_stage.tscn"

var is_changing = false

signal stage_changed

func _ready():
	pass

func change_stage(stage_path):
	if is_changing: return
	
	is_changing = true
	get_tree().get_root().set_disable_input(true)
	
	get_node("anim").play("fade_in")
	yield(get_node("anim"), "finished")
	
	get_tree().change_scene(stage_path)
	emit_signal("stage_changed")
	
	get_node("anim").play("fade_out")
	
	if stage_path == STAGE_GAME:
		sound_manager.play("new_game")
	
	yield(get_node("anim"), "finished")
	
	is_changing = false
	get_tree().get_root().set_disable_input(false)