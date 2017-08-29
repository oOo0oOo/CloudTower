extends RigidBody2D

const up_speed = [260, 75]
const side_speed_factor = 160
const sizes = [180, 235, 290, 340]
const platform_sprites = [
	preload("res://sprites/platform0.png"),
	preload("res://sprites/platform1.png"),
	preload("res://sprites/platform2.png"),
	preload("res://sprites/platform3.png")
]
var side_speed
var allowed_x

onready var state = SelectState.new(self)

func _ready():
	# Which platform type (length)
	var p_type = randi()%4
	
	# Allowed movement range for platform
	var body_width = sizes[p_type]
	allowed_x = [body_width/2 + 10, 720 - body_width/2 - 10]
	
	# Displayed sprite
	var sprite = get_node("Sprite")
	sprite.set_texture(platform_sprites[p_type])
	sprite.set_region_rect(Rect2(0, 0, body_width, 50)) # cropping instead of stretching
	sprite.set_flip_h(randf() < 0.5)
	sprite.set_flip_v(randf() < 0.5)
	
	# Collision shape in the right size (too lazy to improve now)
	var scale = Vector2(float(body_width)/720, 1)
	get_node("CollisionShape2D").set_scale(scale)
	set_scale(scale)
	
	# Larger platforms move slower
	side_speed = max((360.0 / allowed_x[0]) * side_speed_factor, 2 * side_speed_factor)
	side_speed = min(side_speed, 3 * side_speed_factor)
	
	# We need updates
	set_process_input(true)
	set_fixed_process(true)
	
	set_state('select')
	
func set_state(new_state):
	state.exit()
	if new_state == 'select':
		state = SelectState.new(self)
	elif new_state == 'move_up':
		state = MoveUpState.new(self)
	elif new_state == 'idle':
		state = IdleState.new(self)
	
func _fixed_process(delta):
	state.update(delta)
	
func _input(event):
	state.input(event)
	


# Simple State Machine (SelectState -> MoveUpState -> IdleState

class SelectState:
	# During select the plaftorm will move sideways for the user 
	# to position it onto the stack. 
	# This state transitions into the MoveUpState upon click.
	
	var platform
	var direction = 1
	var dude
	
	func _init(platform):
		self.platform = platform
		
		# Its properly initiated (not first time run)
		if platform.allowed_x != null:
			# Random position and direction
			var x = rand_range(platform.allowed_x[0], platform.allowed_x[1])
			platform.set_pos(Vector2(x, 1280-75))
			if randi()%2 == 0:
				direction = -1
			toggle_direction()
			
			# Disable graphity
			platform.set_gravity_scale(0)
			
			dude = utils.get_main_node().get_node("dude")
			
	func toggle_direction():
		direction *= -1
		platform.set_linear_velocity(Vector2(platform.side_speed * direction, 0))
	
	func update(delta):
		if platform.get_pos().x < platform.allowed_x[0]:
			toggle_direction()
		elif platform.get_pos().x > platform.allowed_x[1]:
			toggle_direction()
	
	func input(event):
		# We do not accept any input if de dude has failed...
		if dude.is_failed:
			return
		
		# On click we transition to the MoveUpState
		if event.is_action('click') and event.is_pressed():
			platform.set_state('move_up')
		
	func exit():
		pass
		
		

class MoveUpState:
	# The user has selected a position, now the platform moves up
	var platform
	var spawner_ground
	var ground_top
	
	func _init(platform):
		self.platform = platform
		platform.set_linear_velocity(Vector2(0, -platform.up_speed[0]))
		
		# Setting a very high mass is a hacky way to
		# make the platform "kinematic"
		platform.set_mass(1000000)
		
		# Disable collision with the ground
		spawner_ground = utils.get_main_node().get_node("spawner_ground")
		spawner_ground.set_collision(false, platform)
		ground_top = spawner_ground.get_pos().y
		
		# Play the up sound
		sound_manager.play("swoosh")

	func update(delta):
		# Slow down a little in the end
		if platform.get_pos().y < ground_top + 50:
			platform.set_linear_velocity(Vector2(0, -platform.up_speed[1]))
			
		if platform.get_pos().y < ground_top:
			platform.set_state("idle")
	
	func input(event):
		pass
		
	func exit():
		# Re-enable collision
		spawner_ground.set_collision(true, platform)
		
		
class IdleState:
	# Enable physics, do nothing...
	
	var platform
	
	func _init(platform):
		self.platform = platform
		
		# Reseting mass and gravity is enough, no need to do velocity
		platform.set_gravity_scale(1)
		platform.set_mass(1)
		
		# And we spawn a new platform
		var spawner = utils.get_main_node().get_node("spawner_platform")
		spawner.spawn_platform()

	func update(delta):
		pass
	
	func input(event):
		pass
		
	func exit():
		pass