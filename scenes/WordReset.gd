extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Store.word_reset.connect(_on_word_reset)

func _on_word_reset():
	play()
