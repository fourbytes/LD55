class_name LetterStage
extends Node2D

const BUTTON_SIZE = 128
const MAX_LETTER_COUNT = 10 # The highest amt of letters allowed on the screen.

# Called when the node enters the scene tree for the first time.
func _ready():
	Store.tiles_changed.connect(_on_tiles_changed)

func _on_tiles_changed(tiles: Array[Tile]):
	var viewport_size = get_viewport_rect().size
	
	for child in get_children():
		if child is Sprite2D:
			child.queue_free()

	for tile in Store.selected_tiles:
		var sprite = tile.get_sprite()
		var stage_width = viewport_size.x - BUTTON_SIZE*2 - tile.square_size
		var available_width = stage_width / len(Store.selected_tiles)
		var index = Store.selected_tiles.find(tile)
		var x = (BUTTON_SIZE + tile.square_size/2) + (index * available_width) + (available_width/2)
		var y = viewport_size.y - BUTTON_SIZE/2
		sprite.set_position(Vector2(x, y))
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
