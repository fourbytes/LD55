extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.play('default')
	var viewport_size = get_viewport_rect().size
	self.set_position(Vector2(viewport_size.x/2, viewport_size.y/2 - 64))
