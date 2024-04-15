extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(_on_press)
	self.z_index = 2
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_press():
	Store.deselect_all_tiles()

func _on_mouse_entered():
	self.set_modulate(Color(1.5, 1.5, 1.5, 1))
	
func _on_mouse_exited():
	self.set_modulate(Color(1, 1, 1, 1))
