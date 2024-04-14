extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(_on_press)
	self.z_index = 2

func _on_press():
	Store.deselect_all_tiles()
