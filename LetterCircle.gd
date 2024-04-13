extends Node2D

var letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
var radius = 200
var square_size = 80

func _ready():
	var num_letters = len(letters)
	var angle_step = 2 * PI / num_letters
	var screen_center = get_viewport_rect().get_center()
	
	for i in range(num_letters):
		var angle = i * angle_step
		var x = cos(angle) * radius
		var y = sin(angle) * radius
		
		var square = ColorRect.new()
		square.color = Color.WHITE
		square.set_size(Vector2(square_size, square_size))
		square.set_position(screen_center + Vector2(x - square_size / 2, y - square_size / 2))
		
		add_child(square)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
