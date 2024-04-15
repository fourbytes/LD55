extends ColorRect

const MAX_TILES = 20
const MIN_TILES = 12
const MAX_OPACITY = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	Store.tiles_changed.connect(_on_tiles_changed)
	Store.word_wrong.connect(_on_word_wrong)

func _on_tiles_changed(tiles: Array[Tile]):
	var opacity = minf((float(len(tiles)-MIN_TILES)/MAX_TILES)*MAX_OPACITY, MAX_OPACITY)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "color", Color(255, 0, 0, opacity), 2)

func _on_word_wrong():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "color", Color(255, 0, 0, 0.1), 0.5)
	tween.tween_property(self, "color", Color(255, 0, 0, 0), 0.5)
