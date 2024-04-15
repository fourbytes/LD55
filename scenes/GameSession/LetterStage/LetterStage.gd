class_name LetterStage
extends Node2D

const BUTTON_SIZE = 128
const MAX_LETTER_COUNT = 10 # The highest amt of letters allowed on the screen.
const GAP = 8

# Called when the node enters the scene tree for the first time.
func _ready():
	Store.selected_tiles_changed.connect(_on_selected_tiles_changed)

func _on_selected_tiles_changed(_tiles: Array[Tile]):
	var viewport_size = get_viewport_rect().size
	
	for child in get_children():
		if child is Sprite2D:
			child.queue_free()

	for tile in Store.selected_tiles:
		var sprite = tile.get_sprite()
		var index = Store.selected_tiles.find(tile)
		var letter_width = (len(Store.selected_tiles) - 1) * (tile.square_size + GAP)
		var x = viewport_size.x / 2 - letter_width / 2 + index * (tile.square_size + GAP)
		var y = viewport_size.y - float(BUTTON_SIZE / 2)
		sprite.set_position(Vector2(x, y))
		sprite.z_index = 2
		add_child(sprite)

func _process(_delta):
	var num_letters = len(Store.selected_tiles)

	for i in range(num_letters):
		var sprite = get_child(i)
		if sprite.get_rect().has_point(sprite.get_local_mouse_position()):
			if Input.is_action_just_pressed("select_letter"):
				var tile = Store.selected_tiles[i]
				if tile.isSelected:
					Store.deselect_tile(tile)
