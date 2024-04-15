extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Store.word_wrong.connect(_on_word_wrong)

func _on_word_wrong():
	play()

