extends Node2D

const square_size = 96.0

# Called when the node enters the scene tree for the first time.
func _ready():
	Store.tiles_changed.connect(_on_tiles_changed)

func _on_tiles_changed(tiles: Array[Tile]):
	print(tiles)
	var screen_height = get_viewport_rect().size.y
	
	for child in get_children():
		if child is Sprite2D:
			child.queue_free()
	
	var selected_tiles = []
	for tile in tiles:
		if tile.isSelected:
			selected_tiles.append(tile)
			
	print(selected_tiles)
	
	for tile in selected_tiles:
		var sprite = Sprite2D.new()
		sprite.texture = load("res://assets/sprites/alpha_tiles/letter_" + tile.letter + ".png")
		var sprite_scale = Vector2(square_size / sprite.texture.get_width(), square_size / sprite.texture.get_height())
		sprite.set_scale(sprite_scale)
		sprite.set_position(Vector2((selected_tiles.find(tile) + 1) * square_size * 1.2, screen_height - 250))
		add_child(sprite)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
