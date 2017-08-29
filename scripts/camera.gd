extends Camera2D

const top_margin = 200
const bottom_margin = 230
onready var dude = utils.get_main_node().get_node("dude")

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	# Zoom to keep the dude in view
	# First considering the height
	var height = dude.get_height()
	var min_height = 1280 - bottom_margin - top_margin
	var zoom_y = 1.0
	var x = dude.get_pos().x - 360
	var zoom_y = max(height/min_height, 1.0)
	
	# Then considering the width
	var zoom_x = 1.1 * (720.0 + abs(x)) / 720.0
	var zoom = max(zoom_x, zoom_y)
	
	set_zoom(Vector2(zoom, zoom))
	
	# Now move the camera position
	set_pos(Vector2(x + 360 * (1-zoom), (1-zoom) * 1280))
	