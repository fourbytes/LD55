extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.play('default')
	var viewport_size = get_viewport_rect().size
	self.set_position(Vector2(viewport_size.x/2, viewport_size.y/2))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
