extends Node2D

# TODO: Move letters and selected letters to store.gd
var letters = []
var selected_letters = {}

var square_size = 96.0
var spacing = 160.0

var timer_duration = 1  # Duration in seconds
var rotation_speed = 0.15  # Rotation speed in radians per second

var elapsed_time = 0.0
var tween_duration = 0.5

const LETTER_CHILDREN_OFFSET = 1 # The first child is always the at this stage.

func _ready():
	get_tree().root.size_changed.connect(_on_viewport_size_changed)
	
	# TODO: Move timer into it's own scene.
	# Start the timer
	var timer = Timer.new()
	timer.connect("timeout", _on_timer_timeout)
	timer.set_wait_time(timer_duration)
	timer.set_one_shot(false)  # Make the timer repeat
	add_child(timer)
	timer.start()
	
	update_letters()

func _on_viewport_size_changed():
	update_letters()

func update_letters():
	var num_letters = len(letters)
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
		
		var sprite
		sprite = Sprite2D.new()
		sprite.texture = load("res://assets/sprites/alpha_tiles/letter_" + letters[i] + ".png")
		var sprite_scale = Vector2(square_size / sprite.texture.get_width(), square_size / sprite.texture.get_height())
		sprite.set_scale(sprite_scale)
		sprite.set_position(screen_center + Vector2(x, y))
		
		if selected_letters.has(i):
			var border = Sprite2D.new()
			border.texture = load("res://assets/sprites/alpha_tiles/letter_" + letters[i] + ".png")
			border.self_modulate = Color(1, 0, 0, 1)  # Red color
			sprite.add_child(border)
		
		add_child(sprite)

func _on_timer_timeout():
	# Generate a random letter
	var random_letter = char(randi() % 26 + 65)  # Random uppercase letter (ASCII code)
	
	# Generate a random index to insert the letter
	var random_index = randi() % (len(letters) + 1)
	
	# Insert the random letter at the random index
	letters.insert(random_index, random_letter)
	
	# Update the letters
	update_letters()

func _process(delta):
	elapsed_time += delta
	
	var num_letters = len(letters)
	var angle_step = 2 * PI / num_letters
	var viewport = get_viewport_rect()
	var screen_center = viewport.get_center()
	var radius = (num_letters * spacing) / (2 * PI)
	if radius > min(viewport.size.x, viewport.size.y) / 2:
		letters = []
		selected_letters = {}
		update_letters()
	
	for i in range(num_letters):
		var sprite = get_child(i + LETTER_CHILDREN_OFFSET)
		var angle = i * angle_step + elapsed_time * rotation_speed
		var x = cos(angle) * radius
		var y = sin(angle) * radius
		sprite.set_position(screen_center + Vector2(x, y))
		
		if sprite.get_rect().has_point(sprite.get_local_mouse_position()):
			if Input.is_action_just_pressed("select_letter"):
				var letter = letters[i]
				if selected_letters.has(i):
					selected_letters.erase(i)
				else:
					selected_letters[i] = true
				update_letters()
