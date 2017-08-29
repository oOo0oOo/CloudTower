extends Node

var score_best = 0 setget _set_score_best
var score_current = 0 setget _set_score_current

signal score_current_changed
signal score_best_changed

func _ready():
	randomize()
	stage_manager.connect("stage_changed", self, "_on_stage_changed")
	load_game()

func _on_stage_changed():
	score_current = 0

func _set_score_best(new_value):
	if new_value > score_best:
		score_best = new_value
		save_game()
	
	score_best = new_value
	emit_signal("score_best_changed")
	
func _set_score_current(new_value):
	score_current = new_value
	emit_signal("score_current_changed")
	
func save_game():
	var savegame = File.new()
	savegame.open_encrypted_with_pass("user://cloud_castle.bin", File.WRITE, OS.get_unique_ID())
	savegame.store_line({'score_best': score_best}.to_json())
	print('saved')
	savegame.close()

func load_game():
    var savegame = File.new()
    if !savegame.file_exists("user://cloud_castle.bin"):
        return

    var data = {} # dict.parse_json() requires a declared dict.
    savegame.open_encrypted_with_pass("user://cloud_castle.bin", File.READ, OS.get_unique_ID())
    data.parse_json(savegame.get_line())
    score_best = data['score_best']
    savegame.close()