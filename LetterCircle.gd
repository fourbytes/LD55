extends Node2D

var letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
var radius = 300
var square_size = 256

func _ready():
	get_tree().root.size_changed.connect(_on_viewport_size_changed)
	update_letters()

func _on_viewport_size_changed():
	update_letters()

func update_letters():
	var num_letters = len(letters)
	var angle_step = 2 * PI / num_letters
	var screen_center = get_viewport_rect().get_center()
	
	for child in get_children():
		child.queue_free()
	
	for i in range(num_letters):
		var angle = i * angle_step
		var x = cos(angle) * radius
		var y = sin(angle) * radius
		
		var sprite = Sprite2D.new()
		sprite.texture = load("res://assets/alpha_tiles/letter_" + letters[i] + ".png")
		var sprite_scale = Vector2(square_size / sprite.texture.get_width(), square_size / sprite.texture.get_height())
		sprite.set_scale(sprite_scale)
		
		var sprite_size = sprite.texture.get_size() * sprite_scale
		sprite.set_position(screen_center + Vector2(x, y))
		
		add_child(sprite)

func _process(delta):
	pass
