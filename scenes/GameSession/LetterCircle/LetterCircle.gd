extends Node2D

# Move letters and selected letters to store.gd
const spacing = 128.0

const timer_duration = 2  # Duration in seconds
const rotation_speed = 0.25  # Rotation speed in radians per second

var elapsed_time = 0.0
const tween_duration = 0.5

const LETTER_CHILDREN_OFFSET = 1 # The first child is always the at this stage.

func _ready():
	get_tree().root.size_changed.connect(_on_viewport_size_changed)
	Store.tiles_changed.connect(_on_tiles_changed)
	Store.score_changed.connect(_on_tiles_changed)
	
	# TODO: Move timer into it's own scene.
	# Start the timer
	var timer = Timer.new()
	timer.connect("timeout", _on_timer_timeout)
	timer.set_wait_time(timer_duration)
	timer.set_one_shot(false)  # Make the timer repeat
	add_child(timer)
	timer.start()
	
	update_letters()
	
func _on_score_change(_new_score):
	elapsed_time = 0.0

func _on_tiles_changed(_new_tiles):
	update_letters()

func _on_viewport_size_changed():
	update_letters()

func update_letters():
	print('update letters')
	var num_letters = len(Store.tiles)
	var angle_step = 2 * PI / num_letters
	var screen_center = get_viewport_rect().get_center()
	var radius = (num_letters * spacing) / (2 * PI)
	
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
			var border = Sprite2D.new()
			border.texture = load("res://assets/sprites/alpha_tiles/letter_" + Store.tiles[i].letter + ".png")
			border.self_modulate = Color(1, 0, 0, 1)  # Red color
			border.set_meta('effect_type', 'selected')
			border.z_index = 5
			sprite.add_child(border)
		
		add_child(sprite)

func _on_timer_timeout():
	# Generate a random index to insert the letter
	var random_index = randi() % (len(Store.tiles) + 1)
	
	# Calculate the position of the next tile before adding it
	var num_letters = len(Store.tiles)
	var angle_step = 2 * PI / (num_letters + 1)
	var viewport = get_viewport_rect()
	var screen_center = viewport.get_center()
	var radius = ((num_letters + 1) * spacing) / (2 * PI)
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
	var screen_center = get_viewport_rect().get_center()
	var radius = ((num_letters + 1) * spacing) / (2 * PI)
	
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
	Store.tiles.insert(random_index, Tile.new())

	# Update the letters
	update_letters()

func _process(delta):
	elapsed_time += delta
	
	var num_letters = len(Store.tiles)
	var angle_step = 2 * PI / num_letters
	var viewport = get_viewport_rect()
	var screen_center = viewport.get_center()
	var radius = (num_letters * spacing) / (2 * PI)
	if radius > min(viewport.size.x, viewport.size.y) / 2:
		Store.reset_game()
		return
	
	for i in range(num_letters):
		var sprite = get_child(i + LETTER_CHILDREN_OFFSET)
		var angle = i * angle_step + elapsed_time * rotation_speed
		var x = cos(angle) * radius
		var y = sin(angle) * radius
		sprite.set_position(screen_center + Vector2(x, y))
		
		if sprite.get_rect().has_point(sprite.get_local_mouse_position()):
			var border = Sprite2D.new()
			border.texture = load("res://assets/sprites/alpha_tiles/Tile " + Store.tiles[i].letter + ".png")
			border.self_modulate = Color(0, 1, 0, 1)  # Green color
			border.set_meta('effect_type', 'hover')
			sprite.add_child(border)
			if Input.is_action_just_pressed("select_letter"):
				var tile = Store.tiles[i]
				if tile.isSelected:
					Store.deselect_tile(tile)
				else:
					if len(Store.selected_tiles) < LetterStage.MAX_LETTER_COUNT:
						Store.select_tile(tile)
					else:
						print("Can't select any more letters")
				update_letters()
		else:
			for child_node in sprite.get_children():
				if child_node.get_meta('effect_type') == 'hover':
					sprite.remove_child(child_node)
