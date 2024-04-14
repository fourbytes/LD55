extends Node2D

# Move letters and selected letters to store.gd
const spacing = 128.0
const offset = 80

const timer_duration = 2 # Duration in seconds
const rotation_speed = 0.25 # Rotation speed in radians per second

var elapsed_time = 0.0
const tween_duration = 0.5

const LETTER_CHILDREN_OFFSET = 1 # The first child is always the at this stage.
var screen_center

func _ready():
	self.z_index = 0
	get_tree().root.size_changed.connect(_on_viewport_size_changed)
	Store.tiles_changed.connect(_on_tiles_changed)
	Store.selected_tiles_changed.connect(_on_tiles_changed)
	Store.score_changed.connect(_on_score_change)
	screen_center = get_viewport_rect().get_center() - Vector2(0, 64)
	
	# TODO: Move timer into it's own scene.
	# Start the timer
	var timer = Timer.new()
	timer.connect("timeout", _on_timer_timeout)
	timer.set_wait_time(timer_duration)
	timer.set_one_shot(false) # Make the timer repeat
	add_child(timer)
	timer.start()
	
func _on_score_change(_new_score):
	elapsed_time = 0.0

func _on_viewport_size_changed():
	_on_tiles_changed(null)

func _on_tiles_changed(_new_tiles):
	print('update letters')
	var num_letters = len(Store.tiles)
	var angle_step = 2 * PI / num_letters
	var radius = (num_letters * spacing) / (2 * PI) + offset
	
	for child in get_children():
		if child is Sprite2D:
			child.queue_free()
	
	for i in range(num_letters):
		var angle = i * angle_step + elapsed_time * rotation_speed
		var x = cos(angle) * radius
		var y = sin(angle) * radius
		
		var sprite = Store.tiles[i].get_sprite()
		sprite.set_position(screen_center + Vector2(x, y))
		
		if Store.tiles[i].isSelected:
			sprite.set_self_modulate(Color(1.5, 1.5, 1.5, 1))
			sprite.set_meta('effect_type', 'selected')
		
		add_child(sprite)

func _on_timer_timeout():
	# Generate a random index to insert the letter
	var random_index = randi() % (len(Store.tiles) + 1)
	
	# Calculate the position of the next tile before adding it
	var num_letters = len(Store.tiles)
	var angle_step = 2 * PI / (num_letters + 1)
	var radius = ((num_letters + 1) * spacing) / (2 * PI) + offset
	var angle = random_index * angle_step + elapsed_time * rotation_speed
	var x = cos(angle) * radius
	var y = sin(angle) * radius
	var new_tile_position = screen_center + Vector2(x, y)
	
	# Create a tween animation to expand the circle of tiles
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_method(expand_tiles.bind(random_index, new_tile_position), 0.0, 1.0, tween_duration)
	tween.tween_callback(add_new_tile.bind(random_index))

func expand_tiles(progress, random_index, _new_tile_position):
	var num_letters = len(Store.tiles)
	var angle_step = 2 * PI / (num_letters + 1)
	var radius = ((num_letters + 1) * spacing) / (2 * PI) + offset
	
	for i in range(num_letters):
		var sprite = get_child(i + LETTER_CHILDREN_OFFSET)
		
		# Calculate the target position for the tile
		var target_angle
		if i < random_index:
			target_angle = i * angle_step + elapsed_time * rotation_speed
		else:
			target_angle = (i + 1) * angle_step + elapsed_time * rotation_speed
		
		var target_x = cos(target_angle) * radius
		var target_y = sin(target_angle) * radius
		var target_position = screen_center + Vector2(target_x, target_y)
		
		# Interpolate between the current position and the target position based on progress
		var current_position = sprite.position
		var new_position = current_position.lerp(target_position, progress)
		
		sprite.set_position(new_position)
	

func add_new_tile(random_index):
	# Insert the random letter at the random index
	Store.add_random_tile(random_index)
	# Update the letters

func _process(delta):
	elapsed_time += delta
	
	var num_letters = len(Store.tiles)
	var angle_step = 2 * PI / num_letters
	var viewport = get_viewport_rect()
	var radius = (num_letters * spacing) / (2 * PI) + offset
	if radius > min(viewport.size.x, viewport.size.y - 128) / 2:
		Store.reset_game()
		return
	
	for i in range(num_letters):
		var sprite = get_child(i + LETTER_CHILDREN_OFFSET)
		var angle = i * angle_step + elapsed_time * rotation_speed
		var x = cos(angle) * radius
		var y = sin(angle) * radius
		sprite.set_position(screen_center + Vector2(x, y))
		
		if sprite.get_rect().has_point(sprite.get_local_mouse_position()):
			sprite.set_modulate(Color(1.5, 1.5, 1.5, 1))

			if Input.is_action_just_pressed("select_letter"):
				var tile = Store.tiles[i]
				if tile.isSelected:
					Store.deselect_tile(tile)
				else:
					if len(Store.selected_tiles) < LetterStage.MAX_LETTER_COUNT:
						Store.select_tile(tile)
					else:
						print("Can't select any more letters")

		else:
			for child_node in sprite.get_children():
				if child_node.get_meta('effect_type') == 'hover':
					sprite.remove_child(child_node)
			sprite.set_modulate(Color(1, 1, 1, 1))
