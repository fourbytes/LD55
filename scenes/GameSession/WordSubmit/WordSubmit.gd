extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(_on_press)

func _on_press():
	Store.submit_word()