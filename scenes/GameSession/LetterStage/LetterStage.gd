extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Store.tiles_changed.connect(_on_tiles_changed)

func _on_tiles_changed(tiles: Array[Tile]):
	var screen_height = get_viewport_rect().size.y
	
	for child in get_children():
		if child is Sprite2D:
			child.queue_free()
	
	for tile in Store.selected_tiles:
		var sprite = tile.get_sprite()
		sprite.set_position(Vector2((Store.selected_tiles.find(tile) + 1) * tile.square_size * 1.2, screen_height - 250))
		add_child(sprite)

func _process(delta):
	var num_letters = len(Store.selected_tiles)

	for i in range(num_letters):
		var sprite = get_child(i)
		if sprite.get_rect().has_point(sprite.get_local_mouse_position()):
			if Input.is_action_just_pressed("select_letter"):
				var tile = Store.selected_tiles[i]
				if tile.isSelected:
					Store.deselect_tile(tile)
