extends Node

var words = []

# Called when the node enters the scene tree for the first time.
func _ready():
	load_words()

func is_word_recognised(target_word: String):
	var index = words.find(target_word.to_upper())
	return index != -1

func load_words():
	var file = FileAccess.open("res://scripts/detect_word/recognised_words.txt", FileAccess.READ)
	if file:
		while not file.eof_reached():
			var line = file.get_line()
			if line != "":
				words.append(line)
		file.close()
	else:
		print("Failed to open file.")
