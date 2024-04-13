extends Label

const score_prefix = "Score: "

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_text(score_prefix)
	var store = get_node('../../Store')
	store.score_changed.connect(_on_score_changed)

func _on_score_changed(score: int):
	self.set_text("%s %s" % [score_prefix, str(score)])
