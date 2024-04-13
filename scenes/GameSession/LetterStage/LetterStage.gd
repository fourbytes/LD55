extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Store.tiles_changed.connect(_on_tiles_changed)

func _on_tiles_changed(tiles: Array[Tile]):
	var screen_height = get_viewport_rect().size.y
	var selected_tiles = Store.get_selected_tiles()
	
	for child in get_children():
		if child is Sprite2D:
			child.queue_free()
	
	for tile in selected_tiles:
		var sprite = tile.get_sprite()
		sprite.set_position(Vector2((selected_tiles.find(tile) + 1) * tile.square_size * 1.2, screen_height - 250))
		add_child(sprite)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
