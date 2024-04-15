extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	Store.score_changed.connect(_on_score_changed)
	var viewport_size = get_viewport_rect().size
	set_position(Vector2(viewport_size.x/2.0 - 24, viewport_size.y/2.0))

	_on_score_changed(Store.score)

func _on_score_changed(score: int):
	self.set_text(str(score))
