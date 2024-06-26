extends AudioStreamPlayer

const MAX_TILES = 20
const MIN_TILES = 12
const MIN_SPEED = 120.0/126.0
const MAX_SPEED = MIN_SPEED*1.3

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_pitch_scale(MIN_SPEED)
	Store.tiles_changed.connect(_on_tiles_changed)

func _on_tiles_changed(tiles: Array[Tile]):
	var raw_speed = (float(len(tiles)-MIN_TILES)/MAX_TILES)*MAX_SPEED + MIN_SPEED
	var bounded_speed = maxf(minf(raw_speed, MAX_SPEED), MIN_SPEED)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "pitch_scale", bounded_speed, 2)
