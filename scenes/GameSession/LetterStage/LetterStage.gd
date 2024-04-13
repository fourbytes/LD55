extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var store = get_node('/root/Main/Store')
	store.tiles_changed.connect(_on_tiles_changed)

func _on_tiles_changed(tiles: Array[Tile]):
	var sprite = Sprite2D.new()
	self.children
	#sprite.texture = load("res://assets/sprites/alpha_tiles/letter_" + letters[i] + ".png")
	add_child(sprite)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
