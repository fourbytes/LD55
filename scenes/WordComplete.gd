extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Store.word_complete.connect(_on_word_complete)

func _on_word_complete():
	play()

