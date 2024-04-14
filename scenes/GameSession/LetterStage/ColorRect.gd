extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	var viewport_size = get_viewport_rect().size
	set_position(Vector2(0, viewport_size.y - 128))
	self.size = Vector2(viewport_size.x, 128)
	self.z_index = 1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
